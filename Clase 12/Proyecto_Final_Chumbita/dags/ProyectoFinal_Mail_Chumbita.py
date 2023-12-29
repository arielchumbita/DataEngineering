from datetime import datetime
from email import message
from airflow.models import DAG, Variable
from airflow.operators.python_operator import PythonOperator

import smtplib

def enviar():
    try:
        x=smtplib.SMTP('smtp.gmail.com',587)
        x.starttls()
        x.login('ariel.chumbita@gmail.com','wprozivegdgkpnnn')
        subject='ProyectoFinal_Chumbita'
        body_text='Aviso proyecto final Ariel Chumbita!!!!'
        message='Subject: {}\n\n{}'.format(subject,body_text)
        x.sendmail('ariel.chumbita@gmail.com','ariel-2401@hotmail.com',message)
        print('Exito')
    except Exception as exception:
        print(exception)
        print('Failure')

default_args={
    'owner': 'ArielChumbita',
    'start_date': datetime(2023,12,28)
}

with DAG(
    dag_id='ProyectoFinal_Mail_Chumbita',
    default_args=default_args,
    schedule_interval='@daily') as dag:

    tarea_1=PythonOperator(
        task_id='dag_envio',
        python_callable=enviar
    )

    tarea_1
