#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Inicializar valores
    ui->sliderPresion->setMinimum(950);
    ui->sliderPresion->setMaximum(1050);
    ui->sliderTemperatura->setMinimum(0);
    ui->sliderTemperatura->setMaximum(200);
    ui->sliderHumedad->setMaximum(100);
    ui->sliderHumedad->setMinimum(0);

    connect(ui->sliderPresion, &QSlider::valueChanged, this, &MainWindow::on_sliderPresion_valueChanged);
    connect(ui->sliderTemperatura, &QSlider::valueChanged, this, &::MainWindow::on_sliderTemperatura_valueChanged);
    connect(ui->sliderHumedad, &QSlider::valueChanged, this, &::MainWindow::on_sliderHumedad_valueChanged);



    // Iniciar valores por defecto
    QVector<quint16> inputRegisters(2);
    inputRegisters[0] = ui->sliderPresion->value();
    inputRegisters[1] = ui->sliderTemperatura->value();


    QVector<bool> coils(3, false);

    // Estado inicial de LEDs
    ledrojo = false;
    ledverde = false;
    ledazul = false;

    // MQTT conexión
    mqttClient = new QMqttClient(this);
    mqttClient->setHostname("siimqtt.mooo.com");
    mqttClient->setPort(1883);
    mqttClient->setUsername("group02");
    mqttClient->setPassword("94suxFHjskIhGUW/");

    mqttClient->publish(QMqttTopicName("group02/estadoSensor"), QByteArray("ENCENDIDO"));


    connect(mqttClient, &QMqttClient::messageReceived, this, &MainWindow::handleMqttMessage);

    connect(mqttClient, &QMqttClient::connected, this, [=]() {
        qInfo() << "Conectado al broker MQTT remoto.";

        // Avisar que está encendido
        mqttClient->publish(QMqttTopicName("group02/estadoSensor"), QByteArray("ENCENDIDO"));

        // Suscribirse a los temas del Monitor
        mqttClient->subscribe(QMqttTopicFilter("group02/ledrojo"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledverde"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledazul"));
        mqttClient->subscribe(QMqttTopicFilter("group02/interval"));

        qInfo() << "Suscrito a topics del monitor.";

    });

    connect(mqttClient, &QMqttClient::disconnected, this, [=]() {
        mqttClient->publish(QMqttTopicName("group02/estadoSensor"), QByteArray("APAGADO"));
    });


    // Mensajes recibidos
    connect(mqttClient, &QMqttClient::messageReceived, this, [=](const QByteArray &message, const QMqttTopicName &topic) {
        QString topicName = topic.name();
        QString payload = QString::fromUtf8(message).trimmed();
        qInfo() << " Mensaje recibido en" << topicName << ":" << payload;
        if (topicName.endsWith("interval")) {
            interval = payload.toInt();
        }
        qDebug() << interval;
        qInfo() << "intervalo de transmisión recibido";
    });


    connect(mqttClient, &QMqttClient::errorChanged, this, [](QMqttClient::ClientError error) {
        qWarning() << "Error MQTT:" << error;
    });
    mqttClient->connectToHost();

    //Timer para envío periódico
    envioTimer = new QTimer(this);
    connect(envioTimer, &QTimer::timeout, this, [=]() {
        if (mqttClient->state() == QMqttClient::Connected) {
            /*int presion = ui->sliderPresion->value();
            int temperatura = ui->sliderTemperatura->value();*/
            QString timestamp = QDateTime::currentDateTime().toString(Qt::ISODate);

            mqttClient->publish(QMqttTopicName("group02/presion"), QString::number(currentPreassure).toUtf8());
            mqttClient->publish(QMqttTopicName("group02/temperatura"), QString::number(currentTemperatura).toUtf8());
            mqttClient->publish(QMqttTopicName("group02/humedad"), QString::number(currentHumidity).toUtf8());
            mqttClient->publish(QMqttTopicName("group02/timestamp"), timestamp.toUtf8());

            QString ledStatus = QString("%1,%2,%3").arg(ledrojo).arg(ledverde).arg(ledazul);
            mqttClient->publish(QMqttTopicName("group02/ledStatus"), ledStatus.toUtf8());

            qInfo() << "Enviado: presión=" << currentPreassure << ", temperatura=" << currentTemperatura << ", humedad=" << currentHumidity
                    << ", leds=" << ledStatus;
        }
    });
    envioTimer->start(interval);


}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::handleMqttMessage(const QByteArray &message, const QMqttTopicName &topic)
{
    QString msg = QString(message);
    QString topicStr = topic.name();
    bool isOn = (msg == "1");

    if (topicStr == "group02/ledrojo") {
        ledrojo = isOn;
        ui->indicador1->setStyleSheet(isOn ? "background-color: red" : "background-color: gray");
    } else if (topicStr == "group02/ledverde") {
        ledverde = isOn;
        ui->indicador0->setStyleSheet(isOn ? "background-color: green" : "background-color: gray");
    } else if (topicStr == "group02/ledazul") {
        ledazul = isOn;
        ui->indicador2->setStyleSheet(isOn ? "background-color: blue" : "background-color: gray");
    }

    qInfo() << "Actualizado " << topicStr << " a " << isOn;
}



void MainWindow::on_sliderPresion_valueChanged(int value)
{
    ui->lineEditPresion->setText(QString::number(value));
    currentPreassure = value;
    /*if (mqttClient->state() == QMqttClient::Connected) {
        QString topic = mqttClient->username() + "/presion";
        mqttClient->publish(QMqttTopicName(topic), QString::number(value).toUtf8());
        qInfo() << "Publicado en" << topic << ":" << value;
    }*/
}


void MainWindow::on_sliderTemperatura_valueChanged(int value)
{
    ui->lineEditTemperatura->setText(QString::number(value));
    currentTemperatura = value;
    /*if (mqttClient->state() == QMqttClient::Connected) {
        QString topic = mqttClient->username() + "/temperatura";
        mqttClient->publish(QMqttTopicName(topic), QString::number(value).toUtf8());
        qInfo() << "Publicado en" << topic << ":" << value;
    }*/
}

void MainWindow::on_sliderHumedad_valueChanged(int value)
{
    ui->lineEditHumedad->setText(QString::number(value));
    currentHumidity = value;
    /*if (mqttClient->state() == QMqttClient::Connected) {
        QString topic = mqttClient->username() + "/humedad";
        mqttClient->publish(QMqttTopicName(topic), QString::number(value).toUtf8());
        qInfo() << "Publicado en" << topic << ":" << value;
    }*/
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    if (mqttClient->state() == QMqttClient::Connected) {
        mqttClient->publish(QMqttTopicName("group02/estadoSensor"), QByteArray("APAGADO"));
        mqttClient->disconnectFromHost();
    }

}

