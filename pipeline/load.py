import luigi
import pandas as pd
import logging
import time
import sqlalchemy
import os
from datetime import datetime
from .extract import Extract
from .utils_function.db_connector import db_connector
from .utils_function.read_sql import read_sql_file
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv


# Load environment variables from .env file
load_dotenv()

# Define DIR
DIR_ROOT_PROJECT = os.getenv("DIR_ROOT_PROJECT")
DIR_TEMP_LOG = os.getenv("DIR_TEMP_LOG")
DIR_TEMP_DATA = os.getenv("DIR_TEMP_DATA")
DIR_LOAD_QUERY = os.getenv("DIR_LOAD_QUERY")
DIR_LOG = os.getenv("DIR_LOG")

class Load(luigi.Task):
        
    def requires(self):
        return Extract()
    
    def run(self):
        
        # Configure logging
        logging.basicConfig(
            filename = f'{DIR_TEMP_LOG}/logs.log',
            level = logging.INFO,
            format = '%(asctime)s - %(levelname)s - %(message)s'
        )
         
        # Read extracted data to be load
        try:
            
            # Read address table data
            address = pd.read_csv(self.input()[0].path)
            
            # Read address_status table data
            address_status = pd.read_csv(self.input()[1].path)
            
            # Read author table data
            author = pd.read_csv(self.input()[2].path)
            
            # Read address table data
            book = pd.read_csv(self.input()[3].path)
            
            # Read book_author table data
            book_author = pd.read_csv(self.input()[4].path)
            
            # Read book_language table data
            book_language = pd.read_csv(self.input()[5].path)
            
            # Read country table data
            country = pd.read_csv(self.input()[6].path)
            
            # Read cust_order table data
            cust_order = pd.read_csv(self.input()[7].path)
            
            # Read customer table data
            customer = pd.read_csv(self.input()[8].path)
            
            # Read customer_address table data
            customer_address = pd.read_csv(self.input()[9].path)
            
            # Read order_history table data
            order_history = pd.read_csv(self.input()[10].path)
            
            # Read order_line table data
            order_line = pd.read_csv(self.input()[11].path)
            
            # Read order_status table data
            order_status = pd.read_csv(self.input()[12].path)
            
            # Read publisher table data
            publisher = pd.read_csv(self.input()[13].path)
            
            # Read shipping_method table data
            shipping_method = pd.read_csv(self.input()[14].path)
            
            logging.info(f"Read Extracted Data - SUCCESS!")
            
        except Exception:
            logging.error(f"Read Extracted Data  - FAILED!")
            raise Exception("Failed to Read Extracted Data!")
        
        
        # Establish connection to DWH
        try:
            _, dwh_engine = db_connector()
            logging.info("Connect to DWH - SUCCESS!")
            
        except Exception:
            logging.info(f"Connect to DWH - FAILED!")
            raise Exception("Failed to connect to Data Warehouse!")
        
        
        #----------------------------------------------------------------------------------------------------------------------------------------#
        
        # Truncate all tables in staging schema before load
        # This puropose to avoid errors because duplicate key value violates unique constraint
        
        try:
            
            # Read query to truncate staging schema in DWH
            truncate_staging_query = read_sql_file(
                file_path = f'{DIR_LOAD_QUERY}/truncate_staging_tables.sql'
            )
            
            # Split the SQL queries if multiple queries are present
            truncate_query = truncate_staging_query.split(';')
            
            # Remove newline characters and leading/trailing whitespaces
            truncate_query = [query.strip() for query in truncate_query if query.strip()]
            
            # Create session
            Session = sessionmaker(bind = dwh_engine)
            session = Session()
            
            # Execute each query
            for query in truncate_query:
                query = sqlalchemy.text(query)
                session.execute(query)
                
            session.commit()
            
            # Close session
            session.close()
            
            logging.info(f"Truncate Staging Schema in DWH - SUCCESS!")
        
        except Exception:
            logging.error(f"Truncate Staging Schema in DWH - FAILED!")
            
            raise Exception("Failed to Truncate Staging Schema in DWH!")  

        #----------------------------------------------------------------------------------------------------------------------------------------#
        
        
        # Record start time for loading tables
        start_time = time.time()  
        logging.info("==================================STARTING LOAD DATA=======================================")
        
        # Load to each tables
        try:
            
            try:
                # Load to staging schema in DWH
                
                # Load country tables    
                country.to_sql('country', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load country table - SUCCESS!")      
                
                # Load address tables    
                address.to_sql('address', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load address table - SUCCESS!")
                
                # Load address_status tables    
                address_status.to_sql('address_status', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load address_status table - SUCCESS!")
                
                # Load book_language tables    
                book_language.to_sql('book_language', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load book_language table - SUCCESS!") 

                # Load customer tables    
                customer.to_sql('customer', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load customer table - SUCCESS!") 
                
                # Load publisher tables    
                publisher.to_sql('publisher', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load publisher table - SUCCESS!")
                
                # Load shipping_method tables    
                shipping_method.to_sql('shipping_method', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load shipping_method table - SUCCESS!")
                
                # Load author tables    
                author.to_sql('author', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load author table - SUCCESS!")
                
                # Load book tables    
                book.to_sql('book', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load book table - SUCCESS!")
                
                # Load cust_order tables    
                cust_order.to_sql('cust_order', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load cust_order table - SUCCESS!")
                
                # Load customer_address tables    
                customer_address.to_sql('customer_address', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load customer_address table - SUCCESS!")
                
                # Load order_status tables    
                order_status.to_sql('order_status', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load order_status table - SUCCESS!")
                
                # Load book_author tables    
                book_author.to_sql('book_author', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load book_author table - SUCCESS!")             
                
                # Load order_history tables    
                order_history.to_sql('order_history', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load order_history table - SUCCESS!")
                
                # Load order_line tables    
                order_line.to_sql('order_line', 
                                    con = dwh_engine, 
                                    if_exists = 'append', 
                                    index = False, 
                                    schema = 'stg')
                
                logging.info("Load order_line table - SUCCESS!")
                    
                
                logging.info(f"LOAD All Tables To Pacbook DWH Staging Schema - SUCCESS!")
                
            except Exception:
                logging.error(f"LOAD All Tables To Pacbook DWH Staging Schema - FAILED!")
                raise Exception('Failed Load Tables To Pacbook DWH Staging Schema!')
            
            
            # Record end time for loading tables
            end_time = time.time()  
            execution_time = end_time - start_time  # Calculate execution time
            
            # Get success summary data
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Load'],
                'status' : ['Success'],
                'execution_time': [execution_time]
            }

            # Get success summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write success Summary to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/load_summary.csv", index = False)
            
                        
        #----------------------------------------------------------------------------------------------------------------------------------------#
       
        except Exception:
            
            # Get failed summary data
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Load'],
                'status' : ['Failed'],
                'execution_time': [0]
            }

            # Get failed summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write dailed summary to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/load_summary.csv", index = False)
            
            logging.error("LOAD All Tables to Pacbook DWH Staging Schema - FAILED")
            raise Exception('Failed Load Tables To Pacbook DWH Staging Schema!')   
        
        logging.info("==================================ENDING LOAD DATA=======================================")
        
    #----------------------------------------------------------------------------------------------------------------------------------------#
    def output(self):
        return [luigi.LocalTarget(f'{DIR_TEMP_LOG}/logs.log'),
                luigi.LocalTarget(f'{DIR_TEMP_DATA}/load_summary.csv')]

# Run the task        
if __name__ == '__main__':
    luigi.build([Extract(),
                Load()])
            