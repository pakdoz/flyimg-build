REGISTRY    = https://github.com/flyimg/flyimg.git
APP_PATH    = `pwd`

VERSION     = `git describe --abbrev=0 --tags`
APP_FOLDER  = app-folder
IMAGE_NAME  = flyimg-build:$(VERSION)
IMAGE_PATH  = flyimg/$(IMAGE_NAME)


build:
	rm -rf $(APP_FOLDER)
	git clone $(REGISTRY) $(APP_FOLDER)
	cd $(APP_FOLDER)  && rm -rf .github .gitignore .travis.yml CNAME README.md _config.yml benchmark.sh && \
	docker run -v $(APP_PATH):/var/www/html flyimg/docker-app composer install --no-dev --optimize-autoloader && \
	docker build -t $(IMAGE_NAME) .

push: build
	docker tag $(IMAGE_NAME) $(IMAGE_PATH)
	docker push $(IMAGE_PATH)
	@echo "PUSHED ${IMAGE_PATH}"
	rm -rf $(APP_FOLDER)