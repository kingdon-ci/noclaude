.PHONY: docker

docker:
	docker run \
    --env-file=env -v $(shell pwd)/litellm_config.yaml:/app/config.yaml \
    -p 4000:4000 \
    ghcr.io/berriai/litellm:main-stable \
    --config /app/config.yaml --detailed_debug

# Do not overwrite env!
env:
	cp env.example env
