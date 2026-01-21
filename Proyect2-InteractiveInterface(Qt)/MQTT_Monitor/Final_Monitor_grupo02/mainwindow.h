#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtMqtt/QMqttClient>
#include <QtCharts>
#include <QtCore>
#include <QtGui>
#include <qdebug.h>
#include <QChartView>
#include <QValueAxis>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQueryModel>


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
    void on_Temp_box_stateChanged(int state_temp);

    void on_Pess_box_stateChanged(int state_press);

    void actualizarGrafico();

    void on_pushButton_clicked();

    void on_checkBox_stateChanged(int arg1);

    void on_checkBox_4_stateChanged(int arg1);

    void on_checkBox_5_stateChanged(int arg1);

    void on_dial_valueChanged(int value);

    void on_Conlut_Hm_clicked();

    void on_Conlut_P_clicked();

    void on_Conlut_T_clicked();

private:
    QMqttClient *mqttClient;
    Ui::MainWindow *ui;
   // QGraphicsScene *Scene;
    QTimer *timer;        // Temporizador para actualización periódica
    QChart *chart;  // Gráfico principal
    QChartView *chartView;  // Vista del gráfico
    QChartView *chartView1;  // Vista del gráfico de temperatura
    QChartView *chartView2;  // Vista del gráfico de presión
    QChartView *chartView3;  // Vista del gráfico de humedad
    QChartView *chartView4; // Vista del gráfico de humedad en tiempo real
    QChart *chart1;  // Gráfico temperatura
    QChart *chart2;  // Gráfico presión
    QChart *chart3;  // Gráfico humedad
    QChart *chart4;  // Gráfico humedad tiempo real
    QValueAxis *axisX;  // Eje X (tiempo)
    QValueAxis *axisX2;  // Eje X (tiempo)
    QValueAxis *axisY1;  // Eje Y para presión
    QValueAxis *axisY2;  // Eje Y para temperatura
    QValueAxis *axisY4;  // Eje Y para humedad
    QDateTimeAxis *axisX_HmBd;
    QValueAxis *axisY_HmBd;
    QDateTimeAxis *axisX_PBd;
    QValueAxis *axisY_PBd;
    QDateTimeAxis *axisX_TBd;
    QValueAxis *axisY_TBd;
    int tiempo, time;  // Variable para el eje X    QLineSeries *presionSeries;     // Serie de presión (declarada como miembro)
    QLineSeries *temperaturaSeries;
    QLineSeries *temperaturaSeriesBd;
    QLineSeries *presionSeries;
    QLineSeries *presionSeriesBd;
    QLineSeries *humedadSeries;
    QLineSeries *humedadSeriesBd;
    QCheckBox *checked;
    int state_press_new = Qt::Checked;  // Inicialmente marcado
    int state_temp_new = Qt::Unchecked; // Inicialmente desmarcado
    quint16 currentPressure = 0;
    quint16 currentTemperature = 0;
    double currentHumidity = 0;
    QList<double> listaPresion;
    QList<double> listaTemperatura;
    QList<double> listaHumedad;
    QList<QString> listaTimestamps;
    QString timestamp;
    bool nuevaPresion = false;
    bool nuevaTemperatura = false;
    bool nuevotimestamp = false;
    bool nuevaHumedad = false;
    int mappedValue = 1000;
    bool estadoLedrojo = false;
    bool estadoLedverde = false;
    bool estadoLedazul = false;
    bool encendido = false;


};
#endif // MAINWINDOW_H
