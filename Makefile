build: ## Build image for development
	docker build -t blog .

run: ## Run docker with volume mount
	docker run --rm -p 4000:4000 --name blog -v $(PWD):/srv/jekyll blog serve
	
build-site: ## Build statics files in docker image, 
	docker run --rm -p 4000:4000 --name blog -v $(PWD):/srv/jekyll blog build

build-site-prod: ## Build statics files in docker image, 
	docker run --rm -p 4000:4000 -e JEKYLL_ENV="production" --name blog -v $(PWD):/srv/jekyll blog build

deploy: build-site ## Deploy your static file to s3 bucket
	aws s3 sync $(SITE)/_site s3://$(BUCKET_NAME)

help: ## Display this help. Default target

	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
