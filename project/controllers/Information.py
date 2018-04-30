# -*- coding: utf-8 -*-
from project import app
from project.models.Dashboard import *
from flask import render_template, request
import pickle
from StringIO import StringIO  # Python2
from io import StringIO  # Python3
import sys
import yaml

@app.route("/information/<filename>", methods=['GET'])
def deserialization(filename):
     with open(filename, 'rb') as handle:
        try: 
            # Import the PyYAML dependency

            with open(filename) as yaml_file:

            # Unsafely deserialize the contents of the YAML file
                content = yaml.load(yaml_file)
        except:
            content = "The application was unable to unsserialize object!"
        return render_template("information/index.html", content = content["foo"])
 
