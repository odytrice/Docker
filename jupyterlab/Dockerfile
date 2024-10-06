FROM mcr.microsoft.com/dotnet/sdk:8.0
LABEL maintainer "Ody Mbegbu <odytrice@gmail.com>"

RUN apt-get update
RUN apt-get --assume-yes install apt-transport-https python3-pip libffi-dev python3-dev

RUN pip install jupyterlab jupyterthemes --break-system-packages

RUN dotnet tool install --global Microsoft.dotnet-interactive
ENV PATH "$PATH:/root/.dotnet/tools"
RUN dotnet interactive jupyter install

RUN jupyter kernelspec list

EXPOSE 8888

RUN mkdir /notebooks

CMD ["jupyter", "lab", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--notebook-dir=/notebooks"]