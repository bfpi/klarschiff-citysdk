## Klarschiff-CitySDK
Implementation of CitySDK-Smart-Participation-API for Klarschiff

### Supported Response Formats
JSON, XML

## API Methods

### GET Services (List)
<code>http://[API endpoint]/services.[format]</code>

HTTP Method: GET

Sample Response:

```xml
<services type="array">
  <service>
    <service_code>category.id</service_code>
    <service_name>category.name</service_name>
    <description/>
    <metadata>false</metadata>
    <type>realtime</type>
    <keywords>category.parent.typ [problem|idee|tipp]</keywords>
    <group>category.parent.name</group>
  </service>
</services>
```

### Get Service Definition
<code>http://[API endpoint]/services/[service_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_id | X | Integer |

Sample Response:

```xml
<service_definition type="array">
  <service>
    <service_code>category.id</service_code>
    <service_name>category.name</service_name>
    <keywords>category.parent.typ [problem|idee|tipp]</keywords>
    <group>category.parent.name</group>
  </service>
</service_definition>
```

### Get Service Requests (List)
<code>http://[API endpoint]/requests.[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  | Notes  |
|:--|:-:|:-:|:-:|
| api_key | - | String | API-Key |
| service_request_id | - | Integer | List of multiple Request-IDs, comma delimited |
| service_code | - | Integer | |
| status | - | String | Options: default=open, closed |
| detailed_status |  - | String | Options: PENDING, RECEIVED, IN_PROCESS, PROCESSED, REJECTED |
| start_date | - | Date | e.g 2011-01-01T00:00:00Z |
| end_date | - | Date | e.g 2011-01-01T00:00:00Z |
| updated_after | - | Date | e.g 2011-01-01T00:00:00Z |
| updated_before | - | Date | e.g 2011-01-01T00:00:00Z |
| agency_responsible | - | String | |
| extensions | - | Boolean | |
| lat | - | Double | restriction area (lat, long and radius required)
| long | - | Double | restriction area (lat, long and radius required)
| radius | - | Double | meter - restriction area (lat, long and radius required)
| keyword | - | String | Options: problem, idea, tip |
| max_requests| - | Integer | Maximum number of requests
| observation_key| - | String | MD5-Hash of observed Area

Sample Response:

```xml
<service_requests type="array">
  <request>
    <service_request_id>request.id</service_request_id>
    <status_notes/>
    <status>request.status</status>
    <service_code>request.service.code</service_code>
    <service_name>request.service.name</service_name>
    <description>request.description</description>
    <agency_responsible>request.agency_responsible</agency_responsible>
    <service_notice/>
    <requested_datetime>request.requested_datetime</requested_datetime>
    <updated_datetime>request.updated_datetime</updated_datetime>
    <expected_datetime/>
    <address>request.address</address>
    <adress_id/>
    <lat>request.position.lat</lat>
    <long>request.position.lat</long>
    <media_url/>
    <zipcode/>
  </request>
</service_requests>
```

### Get Service Request
<code>http://[API endpoint]/requests/[service_request_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| api_key | - | String | API-Key |
| extensions | - | Boolean |

Sample Response:

```xml
<service_requests type="array">
  <request>
    <service_request_id>request.id</service_request_id>
    <status_notes/>
    <status>request.status</status>
    <service_code>request.service.code</service_code>
    <service_name>request.service.name</service_name>
    <description>request.description</description>
    <agency_responsible>request.agency_responsible</agency_responsible>
    <service_notice/>
    <requested_datetime>request.requested_datetime</requested_datetime>
    <updated_datetime>request.updated_datetime</updated_datetime>
    <expected_datetime/>
    <address>request.address</address>
    <adress_id/>
    <lat>request.position.lat</lat>
    <long>request.position.lat</long>
    <media_url/>
    <zipcode/>
    <extended_attributes>
      <detailed_status>request.detailed_status</detailed_status>
      <media_urls>
        <media_url>request.media.url</media_url>
      </media_urls>
      <photo_required>request.photo_required</photo_required>
      <trust>request.trust</trust>
      <votes>request.votes</votes>
    </extended_attributes>
  </request>
</service_requests>
```

### Create Service Request
<code>http://[API endpoint]/requests.[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  | Notes  |
|:--|:-:|:-:|:-:|
| api_key | X | String | API-Key |
| email | X | String | Author-Email |
| service_code | X | Integer | Category-ID |
| description | X | String | Description |
| lat | - | Float | either lat & long or address_string |
| long | - | Float | either lat & long or address_string |
| address_string | - | String | either address_string or lat & long |
| photo_required | - | Boolean | Photo required |
| media | - | String | Photo (Base64-Encoded-String) |

Sample Response:

```xml
<service_requests>
  <request>
    <service_request_id>request.id</service_request_id>
  </request>
</service_requests>
```

### Update Service Request
<code>http://[API endpoint]/requests/[service_request_id].[format]</code>

HTTP Method: PUT / PATCH

Parameters:

| Name  | Required  | Type  | Notes  |
|:--|:-:|:-:|:-:|
| api_key | X | String | API-Key |
| email | X | String | Author-Email |
| service_code | - | Integer | Category-ID |
| description | - | String | Description |
| lat | - | Float | either lat & long or address_string |
| long | - | Float | either lat & long or address_string |
| address_string | - | String | either address_string or lat & long |
| photo_required | - | Boolean | Photo required |
| detailed_status | - | String | Status (RECEIVED, IN_PROCESS, PROCESSED, REJECTED) |
| status_notes | - | String | Status note |
| priority | - | Integer | Priority |
| delegation | - | String | Delegation to external role |
| job_status | - | Integer | Job status |
| job_priority | - | Integer | Job priority |
| media | - | String | Photo (Base64-Encoded-String) |

Sample Response:

```xml
<service_requests type="array">
  <request>
    <service_request_id>request.id</service_request_id>
    <status_notes/>
    <status>request.status</status>
    <service_code>request.service.code</service_code>
    <service_name>request.service.name</service_name>
    <description>request.description</description>
    <agency_responsible>request.agency_responsible</agency_responsible>
    <service_notice/>
    <requested_datetime>request.requested_datetime</requested_datetime>
    <updated_datetime>request.updated_datetime</updated_datetime>
    <expected_datetime/>
    <address>request.address</address>
    <adress_id/>
    <lat>request.position.lat</lat>
    <long>request.position.lat</long>
    <media_url/>
    <zipcode/>
  </request>
</service_requests>
```

### Get Comments from Service Request (List)
<code>http://[API endpoint]/requests/comments/[service_request_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  | Notes  |
|:--|:-:|:-:|:-:|
| service_request_id | X | Integer | |
| api_key | X | String | |

Sample Response:

```xml
<comments type="array">
  <comment>
    <id>comment.id</id>
    <jurisdiction_id></jurisdiction_id>
    <comment>comment.text</comment>
    <datetime>comment.datetime</datetime>
    <service_request_id>comment.service_request_id</service_request_id>
  </comment>
</comments>
```

### Create new Comment for Service Request
<code>http://[API endpoint]/requests/comments/[service_request_id].[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| api_key | X | String | |
| author | X | String |
| comment | X | String |

Sample Response:

```xml
<comments>
  <comment>
    <id>comment.id</id>
    <jurisdiction_id></jurisdiction_id>
    <comment>comment.text</comment>
    <datetime>comment.datetime</datetime>
    <service_request_id>comment.service_request_id</service_request_id>
  </comment>
</comments>
```

### Get Notes from Service Request (List)
<code>http://[API endpoint]/requests/notes/[service_request_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| api_key | X | String |

Sample Response:

```xml
<notes type="array">
  <note>
    <jurisdiction_id></jurisdiction_id>
    <comment>note.text</comment>
    <datetime>note.datetime</datetime>
    <service_request_id>note.service_request_id</service_request_id>
    <author>note.author</author>
  </note>
</notes>
```

### Create new Note for Service Request
<code>http://[API endpoint]/requests/notes/[service_request_id].[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| api_key | X | String |
| author | X | String |
| comment | X | String |

Sample Response:

```xml
<notes>
  <note>
    <jurisdiction_id></jurisdiction_id>
    <comment>note.text</comment>
    <datetime>note.datetime</datetime>
    <service_request_id>note.service_request_id</service_request_id>
    <author>note.author</author>
  </note>
</notes>
```


### Create new Abuse for Service Request
<code>http://[API endpoint]/requests/abuses/[service_request_id].[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| author | X | String |
| comment | X | String |

Sample Response:

```xml
<abuses>
  <abuse>
    <id>abuse.id</id>
  </abuse>
</abuses>
```

### Create new Vote for Service Request
<code>http://[API endpoint]/requests/votes/[service_request_id].[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| author | X | String |

Sample Response:

```xml
<votes>
  <vote>
    <id>vote.id</id>
  </vote>
</votes>
```

### Get Position Coverage
<code>http://[API endpoint]/coverage.[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| api_key | X | String |
| lat | X | Float | latitude value |
| long | X | Float | longitude value |

Sample Response:

```xml
<hash>
  <result type="boolean">false</result>
</hash>
```

### Get observable Areas
<code>http://[API endpoint]/areas.[format]</code>

HTTP Method: GET

Parameters:

| Name | Required | Type |
|:--|:-:|:-:|
| api_key | X | String |
| ids | - | String |
| with_districts | - | Boolean |

Sample Response:

```xml
<areas>
  <area>
  <id>30</id>
  <name>Biestow</name>
  <grenze>MULTIPOLYGON (((...)))</grenze>
  </area>
  ...
</areas>
```

### Create new Observation
<code>http://[API endpoint]/observations.[format]</code>

HTTP Method: POST

Parameters:

| Name | Required | Type |
|:--|:-:|:-:|
| api_key | X | String |
| geometry | * | String |
| area_code | * | String |
| problems | - | Boolean |
| problem_service | - | String |
| problem_service_sub | - | String |
| ideas | - | Boolean |
| idea_service | | String |
| idea_service_sub | | String |

*: Either geometry or area_code is required

Sample Response:

```xml
<observation>
  <rss-id>39a855f0a4924af3217a217c8dc78ece</rss-id>
</observatio>
```

## Installation
### Voraussetzungen
- RVM / oder andere Rubyversionsverwaltung
  - Installation von RVM (kann übersprungen werden wenn diese bereits erfolgt ist):
  
    ```bash
    \curl -L https://get.rvm.io | sudo bash -s stable --ruby
    ```
  - Aktualisierung von RVM (falls es bereits systemweit installiert ist)
  
    ```bash
    rvmsudo rvm get stable
    ```
- Passenger-Apache-Modul installieren:
  Hierzu am besten der offiziellen Anleitung unter https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#installation folgen.

### Vorbereitungen
- checkout / clone des Repositories in ein lokales Verzeichnis. Z.B.:

  ```bash
  sudo mkdir -p /var/rails
  cd /var/rails
  git clone https://github.com/bfpi/klarschiff-citysdk.git
  ```
- Installation der notwendigen Rubyversion und des Gemsets
  - Bei Wechsel in das Repository-Verzeichnis hilft RVM mit der Einrichtung
  - Gegebenenfalls muss das entsprechende Ruby installiert werden:
  
    ```bash
    rvm install ruby-2.2.2
    ```
  - Ein erneuter Wechsel in das Verzeichnis legt anschließend die notwendigen Wrapper und das Gemset an
  
    ```bash
    ruby-2.2.2 - #gemset created /usr/local/rvm/gems/ruby-2.2.2@klarschiff-citysdk_r01
    ruby-2.2.2 - #generating klarschiff-citysdk_r01 wrappers................
    ```
  - Falls ```bundler``` nicht (mehr) als Default-Gem durch RVM installiert wird, kann dies wie folgt nachgeholt werden:
  
    ```bash
    gem install bundler --no-ri --no-rdoc
    ```
  - Zur Installation der Gems für die Anwendung ist im Verzeichnis nun folgender Aufruf notwendig:
  
    ```bash
    bundle install
    ```
  
  - Precompilieren der Assets (Bilder)
  
    ```bash
    rake assets:precompile
    ```
    
- Konfiguration der Applikation (Anpassung an die entsprechende Umgebung)
  - Für die Konfigurationsdateien mit vertraulichem Inhalt gibt es versionierbare Vorlagen mit dem Namen `xyz.sample.yml`. Diese müssen kopiert und entsprechend ohne das `sample` als `yxz.yml` benannt werden. Die für die Umgebung gültigen Werte werden dann in der `xyz.yml` konfiguriert.
  - Konfigurationen in der `config/settings.yml`
    - Interne Vorgabewerte werden als Konstanten in dem Block `constants` konfiguriert.
    - Weitere Blöcke sind bisher nicht implementiert.
  - Konfigurationen in der `config/clients.yml`
    In dieser Datei erfolgt die Berechtigungsdefinition für die zu unterstützenden API-Clients.
    - Jeder neue Client wird mit einem eigenene API-Key als Schlüssel in dieser Datei eingefügt.
    - Unterhalb dieses Schlüssels können folgende Werte konfiguriert werden:
      - `name`, ist optional, soll aber für die Verständlichkeit einen Bezeichner des API-Clients tragen können (z.B. Prüf- und Protokoll-Client).
      - `backend_auth_code`, konfiguriert den Authorisierungsschlüssel für die erweiterte Kommunikation mit dem Backend. Dieser muss mit dem Property-Wert `auth.kod_code` in der `settings.properties` im Backend der jeweiligen Zielumgebung übereinstimmen.
      - `permissions`, definiert die für diesen Client erlaubten Berechtigungen. Die Definition erfolgt als YAML-Array, also ein Eintrag pro Zeile. Die Werte werden als Ruby-Symbol geschrieben. Beispiel:
    
        ```yml
        permissions:
          - :create_comments
          - :create_notes
        ```
  - Secrets (`config/secrets.yml`) zur Verschlüsselung der internen Nutzerdaten (Cookies, usw.)
    - Die Konfiguration erfolgt hier nach Rails-Konvention pro Umgebung. Es muss aber nur die Variante mit der entsprechenden Umgebung konfiguriert werden. Also `production` in der Produktivumgebung und der Demo-Umgebung. Die RAILS_ENV `test` ist für automatisierte Tests im Framework vorbehalten.
