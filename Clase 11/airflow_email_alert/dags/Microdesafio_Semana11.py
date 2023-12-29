from datetime import datetime
from email import message
from airflow.models import DAG, Variable
from airflow.operators.python_operator import PythonOperator

import smtplib #Libreria que da el proceso para enviar el mensaje

pais=['Argentina','Brasil','Colombia','Chile','Paraguay','Uruguay','Venezuela','Peru','Ecuador','Bolivia','Mexico']
acronimo= ['AR','BR','CO','CL','PY','UR','VE','PE','EC','BO','MX']
lista_fin_mundo=[2040,2080,2095,2100,2089,2093,2054,2078,2079,2083,2071]

texto=[]

for i in range(len(pais)):
    string='Pais {} ({}), Fecha fin mundo estimada: {}'.format(pais[i], acronimo[i],lista_fin_mundo[i])
    texto.append(string)

final = '\n'.join(texto)
print(final)

def enviar():
    try:
        x=smtplib.SMTP('smtp.gmail.com',587)
        x.starttls()
        x.login('ariel.chumbita@gmail.com','wprozivegdgkpnnn') # Cambia tu contraseña !!!!!!!!
        subject='Fechas fin del mundo'
        body_text=final
        message='Subject: {}\n\n{}'.format(subject,body_text)
        x.sendmail('ariel.chumbita@gmail.com','ariel-2401@hotmail.com',message) #Mail remitente y receptor
        print('Exito')
    except Exception as exception:
        print(exception)
        print('Failure')

default_args={
    'owner': 'ArielChumbita',
    'start_date': datetime(2023,12,28)
}

with DAG(
    dag_id='dag_smtp_email_fin_mundo',
    default_args=default_args,
    schedule_interval='@daily') as dag:

    tarea_1=PythonOperator(
        task_id='dag_envio_fin_mundo',
        python_callable=enviar
    )

    tarea_1
