import os
import subprocess
from dotenv import load_dotenv
from prefect import flow, task

# Cargar variables del .env
load_dotenv()

@task(name="Sincronización Airbyte", log_prints=True)
def run_airbyte():
    conn_id = os.getenv("AIRBYTE_CONNECTION_ID")
    print(f"Iniciando conexión Airbyte ID: {conn_id}")
    return True

@task(name="Ejecución de dbt Build", log_prints=True)
def run_dbt():
    print("Ejecutando dbt build...")
    
    # Expandimos la ruta del usuario para que Python encuentre ~/.dbt/
    profiles_path = os.path.expanduser("~/.dbt/")
    
    # Ejecutamos dbt apuntando explícitamente a tu carpeta de perfiles global
    result = subprocess.run(
        ["dbt", "build", "--profiles-dir", profiles_path], 
        capture_output=True, 
        text=True
    )
    
    print(result.stdout)
    
    if result.returncode != 0:
        print(f"DETALLE DEL ERROR EN DBT:\n{result.stderr}")
        raise Exception("Fallo en la ejecución de dbt")
        
    return True

@flow(name="Pipeline ELT: Brasil API (Gabriel Alvarez)", log_prints=True)
def brasil_api_flow():
    airbyte_ok = run_airbyte()
    if airbyte_ok:
        run_dbt()

if __name__ == "__main__":
    brasil_api_flow()