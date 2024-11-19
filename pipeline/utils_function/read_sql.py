def read_sql_file(file_path):
    """
    This function use to read an SQL file and returns its content as a string.

    Args:
        file_path (str): The path to the SQL file to be read.

    Returns:
        str or None: The content of the SQL file as a string if successful, 
                     or None if an error occurs.

    Note:
        Make sure to handle exceptions properly in the calling code.
        The function assumes that the SQL file is encoded as UTF-8.
    """
    try:
        
        # Open the selected content/file
        with open(file_path, 'r') as file:
            
            # Read the file as a string
            sql_string = file.read()
            
        # Return it as a string
        return sql_string
    
    except Exception as e:
        print(f'An error occured: {e}')
        return None