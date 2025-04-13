chrome:
	@echo "Starting Flutter in Chrome with .env variables..."

	# Read .env and construct dart-define args
	@dart_defines=""; \
	while IFS='=' read -r key value || [ -n "$$key" ]; do \
		if [ -n "$$key" ] && [ -n "$$value" ]; then \
			dart_defines="$$dart_defines --dart-define=$$key=$$value"; \
		fi; \
	done < .env; \
	echo "👉 Running: flutter run -d chrome $$dart_defines"; \
	flutter run -d chrome $$dart_defines