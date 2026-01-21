#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QtCharts>
#include <QTimer>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDateTime>
#include <QMessageBox>
#include <QtSql/QSqlQueryModel>






MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Inicializar base de datos SQLite
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("sensores.db");

    if (!db.open()) {
        qWarning() << "Error al abrir la base de datos:" << db.lastError();
    } else {
        QSqlQuery query;
        query.exec("CREATE TABLE IF NOT EXISTS datos ("
                   "timestamp TEXT, "
                   "sensor TEXT, "
                   "temperatura INTEGER, "
                   "presion INTEGER, "
                   "humedad INTEGER, "
                   "ledrojo INTEGER, "
                   "ledverde INTEGER, "
                   "ledazul INTEGER, "
                   "PRIMARY KEY (timestamp, sensor))");

    }

    tiempo=0;



    // Crear el gráfico
    QChart *chart = new QChart();
    chart->setTitle("Presión y Temperatura en tiempo real");

    // Crear series de datos y guardarlas como atributos de la clase
    presionSeries = new QLineSeries();
    presionSeries->setName("Presión (hPa)");
    presionSeries->setColor(Qt::blue);

    temperaturaSeries = new QLineSeries();
    temperaturaSeries->setName("Temperatura (°C)");
    temperaturaSeries->setColor(Qt::green);

    presionSeries->setVisible(false); // Ocultar la línea
    temperaturaSeries->setVisible(false); // Ocultar la línea

    ui->Temp_box->setChecked(true);
    ui->Pess_box->setChecked(true);


    // Agregar las series al gráfico
    chart->addSeries(presionSeries);
    chart->addSeries(temperaturaSeries);

    // Crear y configurar el eje X
    axisX = new QValueAxis();
    axisX->setTitleText("Tiempo (s)");
    chart->addAxis(axisX, Qt::AlignBottom);
    presionSeries->attachAxis(axisX);
    temperaturaSeries->attachAxis(axisX);

    // Crear y configurar el eje Y para presión
    axisY1 = new QValueAxis();
    axisY1->setTitleText("Presión (hPa)");
    axisY1->setRange(950, 1050);
    chart->addAxis(axisY1, Qt::AlignLeft);
    presionSeries->attachAxis(axisY1);

    // Crear y configurar el eje Y para temperatura
    axisY2 = new QValueAxis();
    axisY2->setTitleText("Temperatura (°C)");
    axisY2->setRange(0,200);
    chart->addAxis(axisY2, Qt::AlignRight);
    temperaturaSeries->attachAxis(axisY2);

    // Crear el QChartView
    chartView = new QChartView(chart);
    chartView->setRenderHint(QPainter::Antialiasing);

    // Configurar el layout de la vista gráfica
    QVBoxLayout *graphicsLayout = new QVBoxLayout(ui->graphicsView);
    ui->graphicsView->setLayout(graphicsLayout);
    graphicsLayout->addWidget(chartView);





    //Grafico Humedad a tiempo real
    QChart *chart4 = new QChart();
    chart4->setTitle("Humedad en tiempo real");

    // Crear series de datos y guardarlas como atributos de la clase
    humedadSeries = new QLineSeries();
    humedadSeries->setName("humedad relativa");
    humedadSeries->setColor(Qt::black);

    //temperaturaSeries->setVisible(false); // Ocultar la línea

    chart4->addSeries(humedadSeries);

    // Crear el QChartView
    chartView4 = new QChartView(chart4);
    chartView4->setRenderHint(QPainter::Antialiasing);

    // Configurar el layout de la vista gráfica
    QVBoxLayout *graphicsLayout4 = new QVBoxLayout(ui->graphicsView_5);
    ui->graphicsView_5->setLayout(graphicsLayout4);
    graphicsLayout4->addWidget(chartView4);

    // Crear y configurar el eje X
    axisX2 = new QValueAxis();
    axisX2->setTitleText("Tiempo (s)");
    chart4->addAxis(axisX2, Qt::AlignBottom);
    humedadSeries->attachAxis(axisX2);

    // Crear y configurar el eje Y para presión
    axisY4 = new QValueAxis();
    axisY4->setTitleText("Humedad");
    axisY4->setRange(0, 100);
    chart4->addAxis(axisY4, Qt::AlignLeft);
    humedadSeries->attachAxis(axisY4);



    // Configurar el temporizador para actualizar la gráfica cada segundo
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &MainWindow::actualizarGrafico);
    connect(ui->dial, &QDial::valueChanged, this, &MainWindow::on_dial_valueChanged);









    //Grafico Temperatura por base de datos
    QChart *chart1 = new QChart();
    chart1->setTitle("Temperatura(Base de datos)");

    // Crear series de datos y guardarlas como atributos de la clase
    temperaturaSeriesBd = new QLineSeries();
    temperaturaSeriesBd->setName("Temperatura (°C)");
    temperaturaSeriesBd->setColor(Qt::red);

      chart1->addSeries(temperaturaSeriesBd);

    // Eje X con tiempo
    axisX_TBd = new QDateTimeAxis();
    axisX_TBd->setTitleText("Tiempo");
    axisX_TBd->setFormat("dd/MM hh:mm:ss");
    chart1->addAxis(axisX_TBd, Qt::AlignBottom);
    temperaturaSeriesBd->attachAxis(axisX_TBd);

    // Eje Y con presión
    axisY_TBd = new QValueAxis();
    axisY_TBd->setTitleText("Presión (hPa)");
    axisY_TBd->setRange(0, 200);
    chart1->addAxis(axisY_TBd, Qt::AlignLeft);
    temperaturaSeriesBd->attachAxis(axisY_TBd);

     // Crear el QChartView
     chartView1 = new QChartView(chart1);
     chartView1->setRenderHint(QPainter::Antialiasing);

     // Limpiar layout y agregar al contenedor
     QLayoutItem *item3;
     while ((item3 = ui->verticalLayout_4->takeAt(0)) != nullptr) {
         delete item3->widget();
         delete item3;
     }
     ui->verticalLayout_4->addWidget(chartView1);







     // Crear el gráfico de presión
     QChart *chart2 = new QChart();
     chart2->setTitle("Presión (Base de datos)");

     // Crear la serie
     presionSeriesBd = new QLineSeries();
     presionSeriesBd->setName("Presión (hPa)");
     presionSeriesBd->setColor(Qt::green);

     chart2->addSeries(presionSeriesBd);

     // Eje X con tiempo
     axisX_PBd = new QDateTimeAxis();
     axisX_PBd->setTitleText("Tiempo");
     axisX_PBd->setFormat("dd/MM hh:mm:ss");
     chart2->addAxis(axisX_PBd, Qt::AlignBottom);
     presionSeriesBd->attachAxis(axisX_PBd);

     // Eje Y con presión
     axisY_PBd = new QValueAxis();
     axisY_PBd->setTitleText("Presión (hPa)");
     axisY_PBd->setRange(950, 1050);
     chart2->addAxis(axisY_PBd, Qt::AlignLeft);
     presionSeriesBd->attachAxis(axisY_PBd);

     // Crear QChartView
     chartView2 = new QChartView(chart2);
     chartView2->setRenderHint(QPainter::Antialiasing);

     // Limpiar layout y agregar al contenedor
     QLayoutItem *item2;
     while ((item2 = ui->verticalLayout_2->takeAt(0)) != nullptr) {
         delete item2->widget();
         delete item2;
     }
     ui->verticalLayout_2->addWidget(chartView2);







     // Crear el gráfico de humedad de la base de datos
     QChart *chart3 = new QChart();
     chart3->setTitle("Humedad (Base de datos)");

     // Crear la serie de humedad
     humedadSeriesBd = new QLineSeries();
     humedadSeriesBd->setName("Humedad relativa");
     humedadSeriesBd->setColor(Qt::red);

     chart3->addSeries(humedadSeriesBd);


     // Eje X con tiempo
     axisX_HmBd = new QDateTimeAxis();
     axisX_HmBd->setTitleText("Tiempo");
     axisX_HmBd->setFormat("dd/MM hh:mm:ss");
     chart3->addAxis(axisX_HmBd, Qt::AlignBottom);
     humedadSeriesBd->attachAxis(axisX_HmBd);

     // Eje Y con humedad relativa
     axisY_HmBd = new QValueAxis();
     axisY_HmBd->setTitleText("Humedad Relativa");
     axisY_HmBd->setRange(0, 100);
     chart3->addAxis(axisY_HmBd, Qt::AlignLeft);
     humedadSeriesBd->attachAxis(axisY_HmBd);


     // Crear el QChartView
     chartView3 = new QChartView(chart3);
     chartView3->setRenderHint(QPainter::Antialiasing);

     // Limpia el layout anterior
     QLayoutItem *item;
     while ((item = ui->verticalLayout->takeAt(0)) != nullptr) {
         delete item->widget();
         delete item;
     }

     // Establecer el layout en tu nuevo widget contenedor de la interfaz
     ui->verticalLayout->addWidget(chartView3);






    // MQTT: Conectar al broker y suscribirse a topics
    mqttClient = new QMqttClient(this);
    mqttClient->setHostname("siimqtt.mooo.com");
    mqttClient->setPort(1883);
    mqttClient->setUsername("group02");
    mqttClient->setPassword("94suxFHjskIhGUW/");

    connect(mqttClient, &QMqttClient::connected, this, [=]() {
        qInfo() << "Conectado al broker MQTT desde el Monitor.";

        // Suscribirse a todos los topics relevantes
        mqttClient->subscribe(QMqttTopicFilter("group02/presion"));
        mqttClient->subscribe(QMqttTopicFilter("group02/temperatura"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledStatus"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledrojo"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledverde"));
        mqttClient->subscribe(QMqttTopicFilter("group02/ledazul"));
        mqttClient->subscribe(QMqttTopicFilter("group02/estadoSensor"));
        mqttClient->subscribe(QMqttTopicFilter("group02/timestamp"));
        mqttClient->subscribe(QMqttTopicFilter("group02/humedad"));
        qInfo() << "Suscrito a topics del Sensor.";
        ui->dial->setValue(1000);
        ui->label_EstadoSensor->setText("OFFLINE");
        ui->label_EstadoSensor->setStyleSheet("color: red; font-weight: bold;");
    });

    // Mensajes recibidos
    connect(mqttClient, &QMqttClient::messageReceived,this, [=](const QByteArray &message, const QMqttTopicName &topic) {
                QString topicName = topic.name();
                QString payload = QString::fromUtf8(message).trimmed();
                qInfo() << " Mensaje recibido en" << topicName << ":" << payload
                    ;
                if (topicName.endsWith("timestamp")) {
                    timestamp = QString(payload);
                    // nuevotimestamp = true;
                }
                else if (topicName.endsWith("presion")) {
                    currentPressure = payload.toDouble();
                    nuevaPresion = true;
                }
                else if (topicName.endsWith("temperatura")) {
                    currentTemperature = payload.toDouble();
                    nuevaTemperatura = true;
                }
                else if(topicName.endsWith("humedad")){
                    currentHumidity = payload.toDouble();
                    nuevaHumedad = true;
                }
                else if (topicName.endsWith("ledrojo")) {
                    estadoLedrojo = payload.toInt();
                }
                else if (topicName.endsWith("ledverde")) {
                    estadoLedverde = payload.toInt();
                }
                else if (topicName.endsWith("ledazul")) {
                    estadoLedazul = payload.toInt();
                }
                else if(topicName.endsWith("estadoSensor") && payload == "ENCENDIDO") {
                    qInfo() << " Sensor ENCENDIDO detectado. Apagando LEDs.";

                    mqttClient->publish(QMqttTopicName("group02/ledverde"), "0");
                    mqttClient->publish(QMqttTopicName("group02/ledrojo"), "0");
                    mqttClient->publish(QMqttTopicName("group02/ledazul"), "0");

                    encendido = true;

                }
                else if (topicName.endsWith("estadoSensor") && payload == "APAGADO") {
                    QMessageBox::information(this, "Estado del Sensor", "El sensor se ha apagado.");
                    encendido = false;
                }

                if(encendido == true){
                    ui->label_EstadoSensor->setText("ONLINE");
                    ui->label_EstadoSensor->setStyleSheet("color: green; font-weight: bold;");
                }
                else if(encendido == false){
                    ui->label_EstadoSensor->setText("OFFLINE");
                    ui->label_EstadoSensor->setStyleSheet("color: red; font-weight: bold;");
                }

                // Solo insertamos si ambos datos están actualizados
                if(nuevaPresion && nuevaTemperatura && nuevaHumedad && encendido){
                    QString sensor = "Sensor1"; // Cambia si usas varios sensores
                    QSqlQuery insertQuery;
                    insertQuery.prepare("INSERT OR REPLACE INTO datos (timestamp, sensor, temperatura, presion, humedad, ledrojo, ledverde, ledazul) "
                                        "VALUES (:timestamp, :sensor, :temperatura, :presion, :humedad, :ledrojo, :ledverde, :ledazul)");
                    insertQuery.bindValue(":timestamp", timestamp);
                    insertQuery.bindValue(":sensor", sensor);
                    insertQuery.bindValue(":temperatura", currentTemperature);
                    insertQuery.bindValue(":presion", currentPressure);
                    insertQuery.bindValue(":humedad", currentHumidity);
                    insertQuery.bindValue(":ledrojo", estadoLedrojo);
                    insertQuery.bindValue(":ledverde", estadoLedverde);
                    insertQuery.bindValue(":ledazul", estadoLedazul);


                    if (!insertQuery.exec()) {
                        qWarning() << "Error al insertar datos en la base de datos:" << insertQuery.lastError();
                    } else {
                        qInfo() << "Datos insertados en la base de datos.";
                    }

                    // Reiniciar flags
                    nuevaPresion = false;
                    nuevaTemperatura = false;
                    nuevaHumedad = false;
                }

            });

    connect(mqttClient, &QMqttClient::disconnected, this, [=]() {
        qWarning() << "Desconectado del broker MQTT.";

        // Actualizar el estado del sensor en la interfaz
        ui->label_EstadoSensor->setText("OFFLINE");
        ui->label_EstadoSensor->setStyleSheet("color: red; font-weight: bold;");
    });


    connect(mqttClient, &QMqttClient::errorChanged, this, [](QMqttClient::ClientError error) {
        qWarning() << "Error MQTT en el Monitor:" << error;
    });

    // Supongamos que tienes dos QDateEdit llamados dateEdit_from_HmBd y dateEdit_to_HmBd
    connect(ui->Conlut_Hm, &QPushButton::clicked, this, &MainWindow::on_Conlut_Hm_clicked);
    connect(ui->Conlut_P, &QPushButton::clicked, this, &MainWindow::on_Conlut_P_clicked);
    connect(ui->Conlut_T, &QPushButton::clicked, this, &MainWindow::on_Conlut_T_clicked);



    mqttClient->connectToHost();


}


MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::actualizarGrafico()
{
    if(encendido){
    ui->Temp_label->setText(QString::number(currentTemperature));
    ui->press_label->setText(QString::number(currentPressure));
    ui->humidity_label->setText(QString::number(currentHumidity));

    if (tiempo < 10) {
        axisX->setRange(0, 10);
        axisX2->setRange(0,10);
    } else {
        axisX->setRange(tiempo - 10, tiempo);
        axisX2->setRange(tiempo - 10, tiempo);

    }

    presionSeries->append(tiempo, currentPressure);
    temperaturaSeries->append(tiempo, currentTemperature);
    humedadSeries->append(tiempo, currentHumidity);
    tiempo++;
}
}



void MainWindow::on_Temp_box_stateChanged(int state_temp)
{
    state_temp_new = state_temp; // Guardar el nuevo estado

    if (state_temp_new == Qt::Checked) {
        temperaturaSeries->setVisible(true);  // Mostrar la línea
    } else if (state_press_new == Qt::Checked) {
        temperaturaSeries->setVisible(false); // Ocultar la línea
    } else {
        // Evitar que ambos se desmarquen
        ui->Temp_box->setChecked(true);
        state_temp_new = Qt::Checked;
    }
}






void MainWindow::on_Pess_box_stateChanged(int state_press)
{
    state_press_new = state_press; // Guardar el nuevo estado

    ui->Pess_box->setChecked(true); //Estado inicial

    if (state_press_new == Qt::Checked) {
        presionSeries->setVisible(true);  // Mostrar la línea
    } else if (state_temp_new == Qt::Checked) {
        presionSeries->setVisible(false); // Ocultar la línea
    } else {
        // Evitar que ambos se desmarquen
        ui->Pess_box->setChecked(true);
        state_press_new = Qt::Checked;
    }
}

void MainWindow::on_pushButton_clicked()
{
    QString from = ui->dateEdit_from->dateTime().toString(Qt::ISODate);
    QString to = ui->dateEdit_to->dateTime().toString(Qt::ISODate);


    // Campos seleccionados según checkboxes
    QStringList campos;
    if (ui->checkBox_3->isChecked()) campos << "presion";
    if (ui->checkBox_2->isChecked()) campos << "temperatura";
    if(ui->checkBox_6->isChecked())  campos << "humedad" ;
    if(ui->checkBox_7->isChecked())  campos << "ledverde" ;
    if(ui->checkBox_8->isChecked())  campos << "ledazul" ;
    if(ui->checkBox_9->isChecked())  campos << "ledrojo" ;
    if (campos.isEmpty()) campos << "presion" << "temperatura" << "humedad" << "ledrojo" << "ledverde" << "ledazul" ; // Por defecto



    QString queryStr = QString("SELECT timestamp, sensor, %1 FROM datos WHERE timestamp BETWEEN '%2' AND '%3'")
                           .arg(campos.join(", "))
                           .arg(from)
                           .arg(to);

    QSqlQueryModel *model = new QSqlQueryModel(this);
    model->setQuery(queryStr);

    if (model->lastError().isValid()) {
        qWarning() << "Error al ejecutar consulta SQL:" << model->lastError();
        return;
    }

    ui->tableView->setModel(model);
}


void MainWindow::on_checkBox_stateChanged(int arg1)
{
    if (arg1 == Qt::Checked) {
        // Checkbox marcado: encender LED
        mqttClient->publish(QMqttTopicName("group02/ledrojo"), "1");
    } else {
        // Checkbox desmarcado: apagar LED
        mqttClient->publish(QMqttTopicName("group02/ledrojo"), "0");
    }
}


void MainWindow::on_checkBox_4_stateChanged(int arg1)
{
    if (arg1 == Qt::Checked) {
        // Checkbox marcado: encender LED
        mqttClient->publish(QMqttTopicName("group02/ledverde"), "1");
    } else {
        // Checkbox desmarcado: apagar LED
        mqttClient->publish(QMqttTopicName("group02/ledverde"), "0");
    }}


void MainWindow::on_checkBox_5_stateChanged(int arg1)
{
    if (arg1 == Qt::Checked) {
        // Checkbox marcado: encender LED
        mqttClient->publish(QMqttTopicName("group02/ledazul"), "1");
    } else {
        // Checkbox desmarcado: apagar LED
        mqttClient->publish(QMqttTopicName("group02/ledazul"), "0");
    }}

void MainWindow::on_dial_valueChanged(int value)
{
    // Por ejemplo, si dejas el QDial con valor mínimo 0 y máximo 100
    int valorMin = 100;
    int valorMax = 2000;
    mappedValue = valorMin + (value * (valorMax - valorMin)) / 100;
    mqttClient->publish(QMqttTopicName("group02/interval"), QByteArray::number(mappedValue));
    qDebug() << "Se publica un intervalo de:" << mappedValue;
    timer->start(mappedValue);  // 1000 ms = 1 segundo

}

void MainWindow::on_Conlut_Hm_clicked()
{
    // Limpiar las listas antes de llenarlas
    listaTimestamps.clear();
    listaHumedad.clear();

    // Limpiar la serie antes de actualizar
    humedadSeriesBd->clear();

    // Leer los datos de la base de datos
    QString from_HmBd = ui->dateEdit_fromHmBd_->dateTime().toString(Qt::ISODate);
    QString to_HmBd = ui->dateEdit_to_HmBd_->dateTime().toString(Qt::ISODate);
    QSqlQuery query;

    QString queryStr = QString("SELECT timestamp, sensor, presion, temperatura, humedad FROM datos WHERE timestamp BETWEEN '%1' AND '%2' ORDER BY timestamp ASC")
                           .arg(from_HmBd)
                           .arg(to_HmBd);

    if (!query.exec(queryStr)) {
        qWarning() << "Error al ejecutar consulta:" << query.lastError().text();
        return;
    }

    while (query.next()) {
        QString ts = query.value(0).toString();
        listaTimestamps.append(ts);
        listaHumedad.append(query.value(4).toDouble());
    }

    // Actualizar gráfica humedad con los datos

    for (int i = 0; i < listaTimestamps.size(); ++i) {
        QDateTime dt = QDateTime::fromString(listaTimestamps[i], Qt::ISODate);
        if (!dt.isValid()) {
            qWarning() << "Timestamp inválido:" << listaTimestamps[i];
            continue;
        }
        qint64 x = dt.toMSecsSinceEpoch();
        int y = listaHumedad[i];
        qDebug() << "Añadiendo punto: " << x << "," << y;
        qDebug() << "Fecha cruda de la BD:" << dt.toString(Qt::ISODate);
        qDebug() << "Timestamp:" << x;
        humedadSeriesBd->append(x, y);
    }
    if (!humedadSeriesBd->points().isEmpty()) {
        qint64 minX = humedadSeriesBd->points().first().x();
        qint64 maxX = humedadSeriesBd->points().last().x();
        axisX_HmBd->setRange(QDateTime::fromMSecsSinceEpoch(minX),
                             QDateTime::fromMSecsSinceEpoch(maxX));
        chartView3->chart()->update();
        chartView3->update();
    }
}


void MainWindow::on_Conlut_P_clicked()
{
    // Limpiar las listas antes de llenarlas
    listaTimestamps.clear();
    listaPresion.clear();

    // Limpiar la serie antes de actualizar
    presionSeriesBd->clear();

    // Leer los datos de la base de datos
    QString from_HmBd = ui->dateEdit_from_PBd->dateTime().toString(Qt::ISODate);
    QString to_HmBd = ui->dateEdit_to_PB->dateTime().toString(Qt::ISODate);
    QSqlQuery query;

    QString queryStr = QString("SELECT timestamp, sensor, presion, temperatura, humedad FROM datos WHERE timestamp BETWEEN '%1' AND '%2' ORDER BY timestamp ASC")
                           .arg(from_HmBd)
                           .arg(to_HmBd);

    if (!query.exec(queryStr)) {
        qWarning() << "Error al ejecutar consulta:" << query.lastError().text();
        return;
    }


    while (query.next()) {
        QString ts = query.value(0).toString();
        listaTimestamps.append(ts);
        listaPresion.append(query.value(2).toDouble());
    }

    // Actualizar presión humedad con los datos

    for (int i = 0; i < listaTimestamps.size(); ++i) {
        QDateTime dt = QDateTime::fromString(listaTimestamps[i], Qt::ISODate);
        if (!dt.isValid()) {
            qWarning() << "Timestamp inválido:" << listaTimestamps[i];
            continue;
        }
        qint64 x = dt.toMSecsSinceEpoch();
        int y = listaPresion[i];
        qDebug() << "Añadiendo punto: " << x << "," << y;
        qDebug() << "Fecha cruda de la BD:" << dt.toString(Qt::ISODate);
        qDebug() << "Timestamp:" << x;
        presionSeriesBd->append(x, y);
    }
    if (!presionSeriesBd->points().isEmpty()) {
        qint64 minX = presionSeriesBd->points().first().x();
        qint64 maxX = presionSeriesBd->points().last().x();
        axisX_PBd->setRange(QDateTime::fromMSecsSinceEpoch(minX),
                             QDateTime::fromMSecsSinceEpoch(maxX));
        chartView2->chart()->update();
        chartView2->update();
    }
}


void MainWindow::on_Conlut_T_clicked()
{
    // Limpiar las listas antes de llenarlas
    listaTimestamps.clear();
    listaTemperatura.clear();

    // Limpiar la serie antes de actualizar
    temperaturaSeriesBd->clear();

    // Leer los datos de la base de datos
    QString from_HmBd = ui->dateEdit_from_TBd->dateTime().toString(Qt::ISODate);
    QString to_HmBd = ui->dateEdit_to_TBd->dateTime().toString(Qt::ISODate);
    QSqlQuery query;

    QString queryStr = QString("SELECT timestamp, sensor, presion, temperatura, humedad FROM datos WHERE timestamp BETWEEN '%1' AND '%2' ORDER BY timestamp ASC")
                           .arg(from_HmBd)
                           .arg(to_HmBd);

    if (!query.exec(queryStr)) {
        qWarning() << "Error al ejecutar consulta:" << query.lastError().text();
        return;
    }

    // Recorrer todas las filas
    while (query.next()) {
        QString ts = query.value(0).toString();
        listaTimestamps.append(ts);
        listaTemperatura.append(query.value(3).toDouble());
    }

    // Actualizar gráfica humedad con los datos

    for (int i = 0; i < listaTimestamps.size(); ++i) {
        QDateTime dt = QDateTime::fromString(listaTimestamps[i], Qt::ISODate);
        if (!dt.isValid()) {
            qWarning() << "Timestamp inválido:" << listaTimestamps[i];
            continue;
        }
        qint64 x = dt.toMSecsSinceEpoch();
        int y = listaTemperatura[i];
        qDebug() << "Añadiendo punto: " << x << "," << y;
        qDebug() << "Fecha cruda de la BD:" << dt.toString(Qt::ISODate);
        qDebug() << "Timestamp:" << x;
        temperaturaSeriesBd->append(x, y);
    }
    if (!temperaturaSeriesBd->points().isEmpty()) {
        qint64 minX = temperaturaSeriesBd->points().first().x();
        qint64 maxX = temperaturaSeriesBd->points().last().x();
        axisX_TBd->setRange(QDateTime::fromMSecsSinceEpoch(minX),
                             QDateTime::fromMSecsSinceEpoch(maxX));
        chartView1->chart()->update();
        chartView1->update();
    }
}

