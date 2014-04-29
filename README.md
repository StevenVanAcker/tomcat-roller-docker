Attempt to get Apache Roller v5.0.1 working with Tomcat 7.0

    # build and run the container
    docker build -t roller .
    docker run --publish=0.0.0.0:8080:8080 --rm -t -i roller

Once the container runs, point a browser towards http://[address]:8080/roller-5.0.1-tomcat
and click on the "Yes - create tables now" button.
Once this step is finished, *DO NOT* overlook the tiny link in:

    Database tables are present and up-to-date. Click here to complete the installation process and start using Roller.

Not clicking this link results in horrible "java.lang.Exception: UNKNOWN ERROR"
