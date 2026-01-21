#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtCharts>
#include <QtCore>
#include <QtGui>
#include <qdebug.h>
#include <QChartView>
#include <QValueAxis>
#include "modbustcp-master.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();


private slots:
    void on_pushButton_clicked();
    void actualizarGrafico();
    void on_Press_box_stateChanged(int state_press);
    void leerDesdeModbus();
    void on_Temp_box_stateChanged(int state_temp);

private:
    ModbusTcpClient client;
    Ui::MainWindow *ui;
    QGraphicsScene *Scene;
    QTimer *timer;        // Temporizador para actualización periódica
    QChart *chart;  // Gráfico principal
    QChartView *chartView;  // Vista del gráfico
    QValueAxis *axisX;  // Eje X (tiempo)
    QValueAxis *axisY1;  // Eje Y para presión
    QValueAxis *axisY2;  // Eje Y para temperatura
    int tiempo, time;  // Variable para el eje X    QLineSeries *presionSeries;     // Serie de presión (declarada como miembro)
    QLineSeries *temperaturaSeries;
    QLineSeries *presionSeries;
    QCheckBox *checked;
    int state_press_new = Qt::Checked;  // Inicialmente marcado
    int state_temp_new = Qt::Unchecked; // Inicialmente desmarcado
    quint16 currentPressure = 0;
    quint16 currentTemperature = 0;
};



#endif // MAINWINDOW_H

