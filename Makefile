REGISTRY    = https://github.com/flyimg/flyimg.git
APP_PATH    = `pwd`

APP_FOLDER  = app-folder
IMAGE_NAME  = flyimg-build
IMAGE_PATH  = flyimg/$(IMAGE_NAME)


build:
	rm -rf $(APP_FOLDER)
	git clone $(REGISTRY) $(APP_FOLDER)
	$(eval VERSION=$(shell sh -c "cd $(APP_FOLDER) && git describe --abbrev=0 --tags"))
	cd $(APP_FOLDER)  && rm -rf .github .gitignore .travis.yml CNAME README.md _config.yml benchmark.sh && \
	docker run -v $(APP_PATH):/var/www/html flyimg/docker-app composer install --no-dev --optimize-autoloader && \
	docker build -t $(IMAGE_NAME):$(VERSION) .

push: build
	$(eval VERSION=$(shell sh -c "cd $(APP_FOLDER) && git describe --abbrev=0 --tags"))
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_PATH):$(VERSION)
	docker push $(IMAGE_PATH):$(VERSION)
	@echo "PUSHED ${IMAGE_PATH}:$(VERSION)"
	rm -rf $(APP_FOLDER)