#!/bin/bash


set -x 

# Start  PostgreSQL service ! 
service postgresql start &


# Process Luxembourg data
# ( this is small ) 
./local-launcher luxembourg
