#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QtCharts>
#include <QTimer>




MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
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

    // Configurar el temporizador para actualizar la gráfica cada segundo
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &MainWindow::actualizarGrafico);
    connect(timer, &QTimer::timeout, this, &MainWindow::leerDesdeModbus);  qDebug() << "Intentando leer desde Modbus...";
    timer->start(1000);  // 1000 ms = 1 segundo



    client.connectToHost("192.168.1.121", 1502);
}

void MainWindow::leerDesdeModbus()
{


    QVector<quint16> registers;
    if (client.readRegisters(0, 2, registers)) {
        currentPressure = registers.at(0);
        currentTemperature = registers.at(1);
        qDebug() << "Presión:" << currentPressure << " mbar, Temperatura:" << currentTemperature << " ºC";
    } else {
        qDebug() << "Error al leer registros.";
    }
    QVector<bool> values;
    if (!client.readDiscreteInputs(0, 2, values)) {
        qFatal() << "Error al leer entradas discretas";
    }
    qDebug() << "Entradas discretas: " << values;
    int en1 = values[0];
    int en2 = values[1];
    QVector<bool> valores;
    if (!client.writeCoils(0x00, valores)) {
        qDebug() << "Error al escribir en las bobinas";
    }
    if(en1 == true){
        valores = QVector<bool>(3, true);  // 3 bobinas en TRUE
        qDebug() << "Correctamente escrito";
        ui->coil1->setText("Rojo");
        ui->coil2->setText("Azul");
        ui->coil3->setText("Verde");
    }
    if(en2 == true){
        valores = QVector<bool>(3, true);  // 3 bobinas en FALSE
        qDebug() << "Correctamente escrito";
        ui->coil1->setText("");
        ui->coil2->setText("");
        ui->coil3->setText("");
    }

}


MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{

    ui->Temp_label->setText(QString::number(currentTemperature));
    ui->press_label->setText(QString::number(currentPressure));
}
void MainWindow::actualizarGrafico()
{

    ui->Temp_label->setText(QString::number(currentTemperature));
    ui->press_label->setText(QString::number(currentPressure));

    axisX->setRange(tiempo - (tiempo % 10), tiempo - (tiempo % 10) + 10);


    presionSeries->append(tiempo, currentPressure);
    temperaturaSeries->append(tiempo, currentTemperature);
    tiempo++;
}


void MainWindow::on_Press_box_stateChanged(int state_press)
{
    state_press_new = state_press; // Guardar el nuevo estado

    if (state_press_new == Qt::Checked) {
        presionSeries->setVisible(true);  // Mostrar la línea
    } else if (state_temp_new == Qt::Checked) {
        presionSeries->setVisible(false); // Ocultar la línea
    } else {
        // Evitar que ambos se desmarquen
        ui->Press_box->setChecked(true);
        state_press_new = Qt::Checked;
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




