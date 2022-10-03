FROM elixir:latest

RUN apt-get update

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex and Rebar package manager.
RUN mix local.hex --force
RUN mix local.rebar --force

#Fetch dependencies
RUN mix deps.get

# Compile the project.
RUN mix do compile

CMD ["/app/entrypoint.sh"]