#!/usr/bin/env python3
import json
import re
from pathlib import Path
from typing import List, Dict, Any

def slugify(text: str) -> str:
    text = text.lower()
    text = re.sub(r'[àáâãäå]', 'a', text)
    text = re.sub(r'[èéêë]', 'e', text)
    text = re.sub(r'[ìíîï]', 'i', text)
    text = re.sub(r'[òóôõö]', 'o', text)
    text = re.sub(r'[ùúûü]', 'u', text)
    text = re.sub(r'[ç]', 'c', text)
    text = re.sub(r'[ñ]', 'n', text)
    text = re.sub(r'[^a-z0-9\s-]', '', text)
    text = re.sub(r'[\s-]+', '-', text)
    text = text.strip('-')
    return text


def main():
    data_path = Path(__file__).parent.parent / 'data' / 'people.json'
    api_path = Path(__file__).parent.parent / 'api'
    preachers_dir = api_path / 'preachers'
    managers_dir = api_path / 'managers'

    api_path.mkdir(exist_ok=True)
    preachers_dir.mkdir(exist_ok=True)
    managers_dir.mkdir(exist_ok=True)

    with open(data_path, 'r', encoding='utf-8') as f:
        people = json.load(f)

    preachers: List[Dict[str, Any]] = []
    managers: List[Dict[str, Any]] = []
    cities_set: set[str] = set()
    themes_set: set[str] = set()

    for person in people:
        person_with_id = person.copy()
        person_with_id['id'] = slugify(person['name'])

        cities_set.add(person['city'])

        if 'themes' in person:
            for theme in person['themes']:
                themes_set.add(theme)

        if 'Preacher' in person['roles']:
            preachers.append(person_with_id)
            preacher_file = preachers_dir / f"{person_with_id['id']}.json"
            with open(preacher_file, 'w', encoding='utf-8') as f:
                json.dump(person_with_id, f, ensure_ascii=False, indent=2)

        if 'Manager' in person['roles']:
            managers.append(person_with_id)
            manager_file = managers_dir / f"{person_with_id['id']}.json"
            with open(manager_file, 'w', encoding='utf-8') as f:
                json.dump(person_with_id, f, ensure_ascii=False, indent=2)

    with open(api_path / 'preachers.json', 'w', encoding='utf-8') as f:
        json.dump(preachers, f, ensure_ascii=False, indent=2)

    with open(api_path / 'managers.json', 'w', encoding='utf-8') as f:
        json.dump(managers, f, ensure_ascii=False, indent=2)

    cities = sorted(list(cities_set))
    with open(api_path / 'cities.json', 'w', encoding='utf-8') as f:
        json.dump(cities, f, ensure_ascii=False, indent=2)

    themes = sorted(list(themes_set))
    with open(api_path / 'themes.json', 'w', encoding='utf-8') as f:
        json.dump(themes, f, ensure_ascii=False, indent=2)

    print(f"Generated {len(preachers)} preachers")
    print(f"Generated {len(managers)} managers")
    print(f"Generated {len(cities)} cities")
    print(f"Generated {len(themes)} themes")
    print(f"Created individual files in {preachers_dir}")
    print(f"Created individual files in {managers_dir}")


if __name__ == '__main__':
    main()
