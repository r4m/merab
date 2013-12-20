HEADER_H=../../TmoteComm.h
BUILD_EXTRA_DEPS += OutputSaver.class

OutputSaver.class: $(wildcard *.java) DataSensorsMsg.java
	javac *.java

DataSensorsMsg.java: $(HEADER_H)
	mig -target=null -java-classname=DataSensorsMsg java $(HEADER_H) data_sensors_msg -o $@

clean:
	rm -f *.class $(GEN)

