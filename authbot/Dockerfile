# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:3.9.4-slim-buster as base

FROM base as build
# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
	apt-get install -y \
	g++ \
	make \
	cmake \
	unzip \
	libcurl4-openssl-dev

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Install the runtime interface client
RUN pip install \
	--target ${FUNCTION_DIR} \
	awslambdaric

COPY requirements.txt .
RUN pip install \
	--target ${FUNCTION_DIR} \
	-r requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM base as run

ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v1.0/aws-lambda-rie /usr/local/bin/aws-lambda-rie
RUN chmod +x /usr/local/bin/aws-lambda-rie

COPY entrypoint.sh .

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build ${FUNCTION_DIR} ${FUNCTION_DIR}
COPY authbot.py ${FUNCTION_DIR}

ENTRYPOINT [ "./entrypoint.sh ]
CMD [ "authbot.cognito_handler" ]
