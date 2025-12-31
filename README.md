# Lumina - Task Manager per iPhone

Un'applicazione moderna e completa per la gestione di task sviluppata in Swift con SwiftUI per iOS.

## 📱 Caratteristiche

- ✅ **Gestione completa dei task**: Crea, modifica, completa ed elimina task
- 🎯 **Priorità**: Assegna priorità (Bassa, Media, Alta) a ogni task
- 📅 **Scadenze**: Imposta date di scadenza con notifiche per task in ritardo
- 🔍 **Ricerca e Filtri**: Cerca task per parole chiave e filtra per priorità e stato
- 📊 **Statistiche**: Visualizza il numero di task da fare, completati e in ritardo
- 💾 **Persistenza locale**: I dati vengono salvati automaticamente su UserDefaults
- 🎨 **UI moderna**: Interfaccia utente pulita e intuitiva con SwiftUI
- 📱 **Supporto iPhone e iPad**: Ottimizzato per tutti i dispositivi iOS

## 🏗️ Struttura del Progetto

```
TaskManager/
├── TaskManager.xcodeproj/          # File progetto Xcode
│   └── project.pbxproj
├── TaskManager/
│   ├── TaskManagerApp.swift        # Entry point dell'app
│   ├── Models/
│   │   └── Task.swift              # Modello dati Task
│   ├── Managers/
│   │   └── TaskManager.swift       # Gestione persistenza e operazioni CRUD
│   ├── Views/
│   │   ├── TaskListView.swift      # Vista principale con lista task
│   │   ├── AddTaskView.swift       # Vista per aggiungere task
│   │   └── TaskDetailView.swift    # Vista dettaglio e modifica
│   ├── Assets.xcassets/            # Risorse e icone
│   └── Info.plist                  # Configurazione app
```

## 🚀 Come Usare

### Requisiti
- Xcode 15.0 o successivo
- iOS 16.0 o successivo
- macOS per sviluppo

### Installazione

1. Clona il repository:
```bash
git clone https://github.com/Ludqvico/Lumina.git
cd Lumina
```

2. Apri il progetto in Xcode:
```bash
open TaskManager/TaskManager.xcodeproj
```

3. Seleziona il target "TaskManager" e un simulatore iOS

4. Premi `Cmd + R` per compilare ed eseguire l'app

## 📖 Funzionalità Principali

### Aggiungere un Task
1. Tocca il pulsante `+` in alto a destra
2. Inserisci titolo (obbligatorio) e descrizione (opzionale)
3. Seleziona la priorità (Bassa, Media, Alta)
4. Opzionalmente imposta una data di scadenza
5. Tocca "Aggiungi Task"

### Modificare un Task
1. Tocca su un task nella lista
2. Nella vista dettaglio, tocca "Modifica"
3. Modifica i campi desiderati
4. Tocca "Salva"

### Completare un Task
- **Swipe da sinistra**: Segna come completato/da fare
- **Nella vista dettaglio**: Tocca l'icona del cerchio

### Eliminare un Task
- **Swipe da destra**: Mostra il pulsante elimina
- **Nella vista dettaglio**: Scorri in basso e tocca "Elimina Task"

### Filtrare i Task
1. Tocca l'icona filtro in alto a sinistra
2. Scegli se mostrare/nascondere task completati
3. Filtra per priorità specifica o visualizza tutti

### Cercare Task
- Usa la barra di ricerca nella lista principale
- Cerca per titolo o descrizione

## 🎨 Caratteristiche UI/UX

- **Swipe Actions**: Swipe veloce per completare o eliminare task
- **Badges di Priorità**: Colori distintivi per ogni livello di priorità
- **Indicatori di Stato**: Icone chiare per task completati/da fare
- **Notifiche Visive**: Task in ritardo evidenziati in rosso
- **Statistiche in Tempo Reale**: Dashboard con contatori aggiornati automaticamente
- **Ricerca Istantanea**: Filtro in tempo reale durante la digitazione

## 💡 Tecnologie Utilizzate

- **Swift**: Linguaggio di programmazione principale
- **SwiftUI**: Framework per l'interfaccia utente
- **Combine**: Per la programmazione reattiva
- **UserDefaults**: Persistenza locale dei dati
- **Codable**: Serializzazione/deserializzazione JSON

## 📝 Modello Dati

Il modello `Task` include:
- `id`: Identificatore univoco (UUID)
- `title`: Titolo del task
- `description`: Descrizione opzionale
- `isCompleted`: Stato di completamento
- `priority`: Livello di priorità (Bassa/Media/Alta)
- `dueDate`: Data di scadenza opzionale
- `createdDate`: Data di creazione

## 🔄 Persistenza

I task vengono automaticamente salvati su UserDefaults ogni volta che:
- Viene aggiunto un nuovo task
- Un task viene modificato
- Un task viene eliminato
- Lo stato di completamento cambia

## 🚧 Possibili Miglioramenti Futuri

- [ ] Integrazione con Core Data per gestione dati più robusta
- [ ] Notifiche push per scadenze imminenti
- [ ] Widget per la schermata home
- [ ] Categorie/Tag personalizzate
- [ ] Modalità scura/chiara
- [ ] Sincronizzazione con iCloud
- [ ] Esportazione/Importazione task
- [ ] Ricorrenze per task ripetitivi
- [ ] Grafici e statistiche avanzate

## 📄 Licenza

Questo progetto è stato creato come esempio educativo.

## 👨‍💻 Sviluppo

Sviluppato con ❤️ usando Swift e SwiftUI