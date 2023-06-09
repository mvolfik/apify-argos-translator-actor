import asyncio

from apify import Actor
from apify.consts import ActorEventTypes

import argostranslate.translate


async def main():
    async with Actor:
        actor_input = await Actor.get_input()

        source_language = "${LANG_CODE}"
        target_language = "en"

        if actor_input.get("from_english"):
            source_language, target_language = target_language, source_language

        translator = argostranslate.translate.get_translation_from_codes(
            source_language, target_language
        )

        print("Translating " + str(translator))

        state = await Actor.get_value("STATE") or {"processed_count": 0}

        async def persist(_):
            await Actor.set_value("STATE", state)

        Actor.on(ActorEventTypes.PERSIST_STATE, persist)

        async def report_stats():
            while True:
                await asyncio.sleep(5)
                msg = f"Translated {state['processed_count']}/{len(actor_input['texts'])} texts"
                await Actor.set_status_message(msg)
                print(msg)

        reporter = asyncio.create_task(report_stats())

        for item in actor_input["texts"][state["processed_count"] :]:
            translations = translator.hypotheses(item)
            await Actor.push_data({"source": item, "translations": translations})
            state["processed_count"] += 1

        reporter.cancel()
