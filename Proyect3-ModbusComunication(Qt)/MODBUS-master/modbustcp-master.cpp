#include "modbustcp-master.h"

// Constructor de la clase ModbusTcpClient.
ModbusTcpClient::ModbusTcpClient(QObject *parent)
    : QObject(parent)
    , transactionId(1) // Se inicializa el ID de transacción en 1.
{
    // Se crea el socket TCP, asignándolo como hijo para gestión automática de memoria.
    socket = new QTcpSocket(this);
}

// Destructor de la clase ModbusTcpClient.
ModbusTcpClient::~ModbusTcpClient()
{
    // Se desconecta el socket del host al destruir la instancia.
    socket->disconnectFromHost();
}

// Método para conectar con un host remoto usando la dirección, puerto y un tiempo de espera.
bool ModbusTcpClient::connectToHost(const QString &host, quint16 port, int timeout)
{
    // Se intenta establecer la conexión con el host especificado.
    socket->connectToHost(host, port);
    // Se espera a que la conexión se establezca o se agote el tiempo.
    if (!socket->waitForConnected(timeout)) {
        qCritical() << "Error de conexión:" << socket->errorString();
        return false;
    }
    return true;
}

// Método que envía una solicitud Modbus (PDU) y espera la respuesta correspondiente.
bool ModbusTcpClient::sendRequest(const QByteArray &pdu, QByteArray &responsePdu, int timeout)
{
    QByteArray request;
    // Se crea un stream para construir el mensaje completo.
    QDataStream stream(&request, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);

    // Se escribe el identificador de la transacción.
    stream << transactionId;
    // Se escribe el identificador del protocolo (0x0000 para Modbus TCP).
    stream << quint16(0x0000);
    // Se calcula la longitud del mensaje: 1 byte para la unidad de identificación más el tamaño del PDU.
    quint16 length = 1 + pdu.size();
    stream << length;
    // Se escribe el identificador de la unidad (normalmente 0x01).
    stream << quint8(0x01);
    // Se añade el PDU al mensaje.
    request.append(pdu);

    qDebug() << "Datos de solicitud: " << request.toHex();
    // Se envía la solicitud a través del socket.
    socket->write(request);
    // Se espera a que se hayan escrito todos los datos.
    if (!socket->waitForBytesWritten(timeout)) {
        qCritical() << "Error al escribir en el socket:" << socket->errorString();
        return false;
    }

    QByteArray header;
    // Se lee el encabezado de la respuesta (debe tener 7 bytes).
    while (header.size() < 7) {
        if (!socket->waitForReadyRead(timeout)) {
            qCritical() << "Tiempo de espera agotado al esperar el encabezado. timeout=="
                        << timeout;
            return false;
        }
        header.append(socket->read(7 - header.size()));
    }

    // Se procesa el encabezado recibido.
    QDataStream headerStream(header);
    headerStream.setByteOrder(QDataStream::BigEndian);
    quint16 respTransactionId, protocolId, respLength;
    quint8 unitId;
    headerStream >> respTransactionId >> protocolId >> respLength >> unitId;

    // Se verifica que el ID de transacción de la respuesta coincida con el enviado.
    if (respTransactionId != transactionId) {
        qCritical() << "Desajuste en el ID de transacción " << respTransactionId
                    << "!=" << transactionId;
        return false;
    }
    ++transactionId; // Se incrementa el ID de transacción para la próxima solicitud.

    // Se calcula la cantidad de bytes restantes que deben leerse (excluyendo la unidad de identificación).
    int remaining = respLength - 1;
    QByteArray responseBuffer;
    // Se lee el resto de la respuesta.
    while (responseBuffer.size() < remaining) {
        if (socket->bytesAvailable() == 0 && !socket->waitForReadyRead(timeout)) {
            qCritical() << "Tiempo de espera agotado al esperar la respuesta completa. timeout=="
                        << timeout;
            return false;
        }
        responseBuffer.append(socket->read(remaining - responseBuffer.size()));
    }
    // Se almacena la parte de la respuesta que corresponde al PDU.
    responsePdu = responseBuffer;
    qDebug() << "Datos de respuesta: " << responsePdu.toHex();
    return true;
}

// Función auxiliar para desempaquetar los bits recibidos en el formato Modbus.
// Lee 'bitCount' bits desde el QDataStream y los almacena en un QVector<bool>.
static QVector<bool> unpackModbusBits(QDataStream &stream, quint16 bitCount)
{
    QVector<bool> bits;
    bits.reserve(bitCount); // Reserva espacio para los bits.

    quint8 byte;
    // Se recorre cada bit solicitado.
    for (quint16 i = 0; i < bitCount; ++i) {
        // Cada 8 bits se lee un nuevo byte del stream.
        if (i % 8 == 0) {
            stream >> byte;
        }
        // Se añade el valor del bit (comprobando si está activo o no).
        bits.append(byte & (1 << (i % 8)));
    }
    return bits;
}

// Método para leer entradas discretas a partir de una dirección y cantidad.
bool ModbusTcpClient::readDiscreteInputs(quint16 address, quint16 count, QVector<bool> &ret)
{
    // Código de función Modbus para leer entradas discretas.
    const quint8 FUNCTION_CODE = 0x02;

    // Se prepara el PDU (Unidad de Datos del Protocolo) para la solicitud.
    QByteArray pdu;
    QDataStream pduStream(&pdu, QIODevice::WriteOnly);
    pduStream.setByteOrder(QDataStream::BigEndian); // Se usa el orden de bytes Big Endian.
    pduStream << FUNCTION_CODE << address << count;

    QByteArray responsePDU;
    // Se envía la solicitud y se espera la respuesta.
    if (!sendRequest(pdu, responsePDU))
        return false;

    // Se procesa la respuesta recibida.
    QDataStream respStream(responsePDU);
    respStream.setByteOrder(QDataStream::BigEndian);
    quint8 functionCode, byteCount;
    respStream >> functionCode >> byteCount;
    // Se verifica que la respuesta tenga el código de función y la cantidad de bytes esperados.
    if (functionCode != FUNCTION_CODE || byteCount != (count + 7) / 8) {
        qCritical() << "Respuesta inesperada para readCoil: Recibido: f==" << functionCode
                    << " count==" << byteCount;
        return false;
    }

    // Se desempaquetan los bits y se guardan en 'ret'.
    ret = unpackModbusBits(respStream, count);
    return true;
}

// Método para leer registros a partir de una dirección y cantidad.
bool ModbusTcpClient::readRegisters(quint16 startAddress, quint16 count, QVector<quint16> &registers)
{
    const quint8 FUNCTION_CODE = 0x04;

    // Construcción del PDU de petición
    QByteArray pdu;
    QDataStream pduStream(&pdu, QIODevice::WriteOnly);
    pduStream.setByteOrder(QDataStream::BigEndian);
    pduStream << FUNCTION_CODE << startAddress << count;

    // Enviar petición y recibir respuesta
    QByteArray responsePDU;
    if (!sendRequest(pdu, responsePDU))
        return false;

    // Procesar respuesta
    QDataStream respStream(responsePDU);
    respStream.setByteOrder(QDataStream::BigEndian);

    quint8 functionCode;
    quint8 byteCount;

    respStream >> functionCode >> byteCount;
    qDebug() << functionCode;

    if (functionCode != FUNCTION_CODE) {
        qCritical() << "Respuesta inesperada para readRegisters.";
        return false;
    }

    if (byteCount != count * 2) {
        qCritical() << "Cantidad de datos recibida no coincide con la esperada.";
        return false;
    }

    registers.clear();
    for (int i = 0; i < count; ++i) {
        quint16 reg;
        respStream >> reg;
        registers.append(reg);
    }

    return true;
}


bool ModbusTcpClient::writeCoils(quint16 address, const QVector<bool> &values)
{
    qDebug() << "Valores a escribir:" << values;

    if (values.isEmpty()) {
        qCritical() << "No hay valores para escribir en las bobinas.";
        return false;
    }

    const quint8 FUNCTION_CODE = 0x0F; // Código de función Modbus para escribir múltiples bobinas.
    quint16 count = values.size();
    quint8 byteCount = (count + 7) / 8; // Se calculan los bytes necesarios para los bits.

    // Construcción del PDU (Protocol Data Unit)
    QByteArray pdu;
    QDataStream pduStream(&pdu, QIODevice::WriteOnly);
    pduStream.setByteOrder(QDataStream::BigEndian);

    // Primero se escribe el código de función, dirección y cantidad de bobinas.
    pduStream << FUNCTION_CODE << address << count << byteCount;

    // Se crean los datos de las bobinas empaquetados en bytes.
    QByteArray coilData(byteCount, 0x00);
    for (int i = 0; i < count; ++i) {
        if (values[i]) {
            coilData[i / 8] |= (1 << (i % 8));
        }
    }
    pdu.append(coilData);

    // Se envía la solicitud Modbus.
    QByteArray responsePDU;
    if (!sendRequest(pdu, responsePDU)) {
        qCritical() << "Error al enviar la solicitud Modbus.";
        return false;
    }

    qDebug() << "Respuesta Modbus recibida:" << responsePDU.toHex(); // Mostrar respuesta en formato HEX.

    // Procesar la respuesta Modbus.
    QDataStream respStream(responsePDU);
    respStream.setByteOrder(QDataStream::BigEndian);

    quint8 functionCode;
    quint16 responseAddress, responseCount;

    if (responsePDU.size() < 5) {  // Validar que la respuesta tenga al menos 5 bytes.
        qCritical() << "Respuesta Modbus demasiado corta.";
        return false;
    }

    respStream >> functionCode >> responseAddress >> responseCount;

    if (functionCode != FUNCTION_CODE) {
        qCritical() << "Código de función inesperado en la respuesta: " << functionCode;
        return false;
    }

    if (responseAddress != address || responseCount != count) {
        qCritical() << "Respuesta inválida para writeCoils. Dirección o cantidad incorrecta.";
        return false;
    }

    qDebug() << "Bobinas escritas correctamente en Modbus.";
    return true;
}

bool ModbusTcpClient::readCoils(quint16 startAddress, quint16 count, QVector<bool> &values)
{
    // Código de función Modbus para leer bobinas (coils).
    const quint8 FUNCTION_CODE = 0x01;

    // Se prepara el PDU con el código de función, dirección inicial y cantidad de bobinas a leer.
    QByteArray pdu;
    QDataStream pduStream(&pdu, QIODevice::WriteOnly);
    pduStream.setByteOrder(QDataStream::BigEndian);
    pduStream << FUNCTION_CODE << startAddress << count;

    QByteArray responsePDU;
    // Se envía la solicitud y se espera la respuesta.
    if (!sendRequest(pdu, responsePDU)) {
        qCritical() << "Error al enviar la solicitud Modbus.";
        return false;
    }

    // Se procesa la respuesta.
    QDataStream respStream(responsePDU);
    respStream.setByteOrder(QDataStream::BigEndian);

    // Leer código de función de la respuesta
    quint8 functionCode, byteCount;
    respStream >> functionCode >> byteCount;

    // Verificar que la respuesta es válida
    if (functionCode != FUNCTION_CODE) {
        qCritical() << "Respuesta inesperada para readCoils. Código recibido:" << functionCode;
        return false;
    }

    // Verificar que la cantidad de bytes es suficiente
    if (byteCount < (count + 7) / 8) {
        qCritical() << "La respuesta tiene menos datos de los esperados.";
        return false;
    }

    // Extraer bits correctamente
    values = unpackModbusBits(respStream, count);

    qDebug() << "Bobinas leídas correctamente:" << values;
    return true;
}
