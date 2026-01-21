#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtMqtt/QMqttClient>
#include <QTimer>

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

    void on_sliderPresion_valueChanged(int value);

    void on_sliderTemperatura_valueChanged(int value);

    void handleMqttMessage(const QByteArray &message, const QMqttTopicName &topic);


    void on_sliderHumedad_valueChanged(int value);

private:
    Ui::MainWindow *ui;
    QMqttClient *mqttClient;
    quint16 currentPreassure= 0, currentTemperatura = 0, currentHumidity = 0;
    QTimer *envioTimer;
    bool ledrojo, ledverde, ledazul;
    int interval;

protected:
    void closeEvent(QCloseEvent *event) override;
};
#endif // MAINWINDOW_H
