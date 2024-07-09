# Busca por uma imagem do dockerhub e cria um alias chamado builder
FROM golang:1.22.4-alpine as builder

# Cria e define como diretorio atual
WORKDIR /app

# Copia arquivos para dentro da imagem
COPY go.mod go.sum ./

# Fazer download de dependencias e instalar
RUN go mod download && go mod verify

# Copiar todos arquivos
COPY . .

# Fazer o build da aplicação dentro de uma pasta bin
RUN go build -o /bin/journey ./cmd/journey/journey.go

# Cria uma nova imagem sem dependências -> multi-stage build
FROM scratch

# Define o diretório padrão
WORKDIR /app

# Copia o binário criado no builder para o diretório 
COPY --from=builder /bin/journey .

# Expor uma porta do container
EXPOSE 8080

# Indica qual o entrypoint dentro do container
ENTRYPOINT [ "./journey" ]