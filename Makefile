.PHONY: generate
generate:
	@echo "Generating API files from people.json..."
	@python3 scripts/generate_api.py
	@echo "Done!"
