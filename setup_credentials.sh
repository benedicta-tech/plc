#!/bin/bash

set -e

echo "🔐 PLC App - Credentials Setup"
echo "================================"
echo ""

if [ -f ".env" ]; then
    echo "⚠️  .env already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

echo "Please choose an option:"
echo "1) I have a service_account.json file"
echo "2) I want to manually paste the JSON content"
echo "3) I want to create from template (you'll need to edit it manually)"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        read -p "Enter the path to your service_account.json file: " service_account_path

        if [ ! -f "$service_account_path" ]; then
            echo "❌ Error: File not found at $service_account_path"
            exit 1
        fi

        service_account_content=$(cat "$service_account_path" | jq -c .)
        echo "GOOGLE_SERVICE_ACCOUNT=$service_account_content" > .env
        echo "✅ .env created successfully from $service_account_path"
        ;;

    2)
        echo "Please paste your service account JSON (press Ctrl+D when done):"
        service_account_content=$(cat)

        echo "$service_account_content" | jq -c . > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "❌ Error: Invalid JSON format"
            exit 1
        fi

        service_account_content=$(echo "$service_account_content" | jq -c .)
        echo "GOOGLE_SERVICE_ACCOUNT=$service_account_content" > .env
        echo "✅ .env created successfully"
        ;;

    3)
        cp .env.template .env
        echo "✅ .env created from template"
        echo "⚠️  You need to edit .env and replace the placeholder values with your actual credentials"
        ;;

    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "📝 Next steps:"
echo "1. Run: flutter pub get"
echo "2. Run: dart run build_runner build --delete-conflicting-outputs"
echo "3. Run: flutter run"
echo ""
echo "For building:"
echo "  - Debug: flutter build apk --debug"
echo "  - Release: flutter build apk --release"
echo ""
echo "✨ Setup complete!"
