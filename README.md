# Bugillionaire - Projektbeschreibung & Dokumentation

**Thematik:** Ein Top-Down Pixelart-Inkremental-Spiel, in dem der Spieler als Insektenvernichter durch das Auslöschen von Insekten reich wird. Ziel ist es, durch kontinuierliches Vernichten Geld zu verdienen, um immer stärkere Upgrades und übertriebene Waffen (von den bloßen Händen über Fliegenklatschen bis hin zu Insektenvernichtungsspray und futuristischen Geräten) freizuschalten.

---

## 1. Core Loop (Spielschleife)

Der Kern des Spiels basiert auf einem kontinuierlichen Kreislauf, der sich in den ersten Versionen (v0.0.1 und v0.0.2) wie folgt etabliert hat:

1. **Spawning:** Ein automatischer Timer (`InsectSpawner`) generiert in regelmäßigen Abständen neue Insekten an zufälligen Positionen auf dem Hauptspielfeld (`MainLevel`).
2. **Interaktion & Schaden:** Der Spieler klickt auf die Insekten (`Area2D`). Jeder Klick reduziert die Lebenspunkte (`health`) des Insekts.
3. **Belohnung:** Erreicht die Lebenspunkte eines Insekts 0, wird das Objekt aus dem Speicher gelöscht (`queue_free()`) und eine Währungsgutschrift über das globale Singleton (`GameState`) ausgelöst.
4. **UI-Aktualisierung:** Das Geld-UI (`MoneyUI`) reagiert ereignisbasiert auf das Signal des GameStates und aktualisiert den Kontostand in Echtzeit.
5. **Runden-Limit:** Ein 60-Sekunden-Runden-Timer (`RoundTimer`) limitiert die aktive Jagdphase. Nach Ablauf der Zeit stoppt der Spawner, und das Spiel wechselt in die nächste Phase (Upgrade-Shop).

---

## 2. Wichtige Projekt-Links & Ressourcen

* **Projektmanagement (Tududi):** [Tududi Bugillionaire Board](https://projekt.datorsida.de/project/sbrpksrm4g7tszq-bugillionaire)
* **Versionsverwaltung (Forgejo):** [Forgejo Repository](https://dev.datorsida.de/LeFix_Dev/Bugillionaire)
* **Lokaler Speicherort:** `P:\Projekte & Assets\Projekte Godot\Godot 4.x.x Projekte\Projekte\Bugillionaire`
* **Entwicklungsbegleitung:** Aktueller Chat (KI-Collaborator)

---

## 3. Technische Struktur & Architektur (Godot 4)

* **Autoloads (Singletons):** `GameState.gd` verwaltet globale Werte wie Währung und Multiplikatoren.
* **Szenen-Struktur:**
* `scenes/levels/MainLevel.tscn` (Hauptspiel mit Spawner und Timern)
* `scenes/entities/Insect.tscn` (Klickbare Insekten-Entität)
* `scenes/ui/` (Beinhaltet `MoneyUI`, `MainMenu` und `PauseMenu`)


* **Steuerung & Pause:** Über `_unhandled_input` (ESC-Taste) wird der gesamte `SceneTree` pausiert, während das Pausenmenü dank `Process Mode: Always` aktiv bleibt.