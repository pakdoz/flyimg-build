REGISTRY    = https://github.com/pakdoz/flyimg.git
APP_PATH    = `pwd`

.PHONY: build push

APP_FOLDER  = app-folder
IMAGE_NAME  = flyimg-build-arm
IMAGE_PATH  = preketek/$(IMAGE_NAME)

build:
	rm -rf $(APP_FOLDER)
	git clone $(REGISTRY) $(APP_FOLDER)
	$(eval VERSION=$(shell sh -c "cd $(APP_FOLDER) && git describe --abbrev=0 --tags"))
	cd $(APP_FOLDER)  && rm -rf .github .gitignore .travis.yml CNAME README.md _config.yml benchmark.sh && \
	docker run -v $(APP_PATH):/var/www/html preketek/flyimg-base-arm:1.1.0 composer install --no-dev --optimize-autoloader && \
	docker build -t $(IMAGE_NAME):$(VERSION) .

push: build
	$(eval VERSION=$(shell sh -c "cd $(APP_FOLDER) && git describe --abbrev=0 --tags"))
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_PATH):$(VERSION)
	docker push $(IMAGE_PATH):$(VERSION)
	docker push $(IMAGE_PATH)
	@echo "PUSHED ${IMAGE_PATH}:$(VERSION)"
	rm -rf $(APP_FOLDER)
