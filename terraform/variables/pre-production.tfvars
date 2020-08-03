region = "eu-west-2"

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
webservers_cpu = 256
webservers_memory = 512
webservers_image = "webservers:latest"
webservers_http_port = 80
webservers_websockets_port = 8080
webservers_count = 1
