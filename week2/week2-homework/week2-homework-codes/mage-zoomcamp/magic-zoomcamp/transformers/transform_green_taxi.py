if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import pandas as pd

@transformer
def transform(data, *args, **kwargs):
    # Specify your transformation logic here
    non_zero_passenger_trip_df = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    #non_zero_passenger_trip_count = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]['passenger_count'].count()
    non_zero_passenger_trip_df['lpep_pickup_date'] = non_zero_passenger_trip_df['lpep_pickup_datetime'].dt.date


    # Step 1: Store the original column names
    original_columns = non_zero_passenger_trip_df.columns.tolist()




    non_zero_passenger_trip_df.columns=(non_zero_passenger_trip_df.columns
                    .str.replace(' ','_')
                    .str.lower()
                    
    )
    new_columns = non_zero_passenger_trip_df.columns.tolist()
    adjusted_columns = [new for original, new in zip(original_columns, new_columns) if original != new]

# Number of columns adjusted
    num_adjusted_columns = len(adjusted_columns)
    print(f"Number of columns adjusted: {num_adjusted_columns}")
    data=non_zero_passenger_trip_df
    #return non_zero_passenger_trip_df
    unique_vendorids = non_zero_passenger_trip_df['vendorid'].unique()
    print(unique_vendorids.tolist())
    unique_dates = non_zero_passenger_trip_df['lpep_pickup_date'].unique()
    print(len(unique_dates))
    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
# Extract unique values from 'vendor_id'
    unique_vendorids = output['vendorid'].unique()
    

# Assert that each 'vendor_id' is one of the unique values (This will always be true)
    assert output['vendorid'].isin(unique_vendorids).all(), "Some 'vendor_id' values are not in the list of existing values"

# Assertion 2: 'passenger_count' is greater than 0
    assert (output['passenger_count'] > 0).all(), "'passenger_count' contains values less than or equal to 0"

# Assertion 3: 'trip_distance' is greater than 0
    assert (output['trip_distance'] > 0).all(), "'trip_distance' contains values less than or equal to 0"


