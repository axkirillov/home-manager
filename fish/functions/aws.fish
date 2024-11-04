function docker-login-aws
	aws ecr get-login-password --profile mp-shared-developer | docker login --username AWS --password-stdin 623240091614.dkr.ecr.eu-central-1.amazonaws.com
end
