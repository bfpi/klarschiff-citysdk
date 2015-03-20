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
    <keywords>category.parent.typ [problem|idee]</keywords>
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
    <keywords>category.parent.typ [problem|idee]</keywords>
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
| service_request_id | - | Integer | List of multiple Request-IDs, comma delimited |
| service_code | - | Integer | |
| status | - | String | Options: default=open, closed |
| start_date | - | Date | e.g 2011-01-01T00:00:00Z |
| end_date | - | Date | e.g 2011-01-01T00:00:00Z |
| updated_after | - | Date | e.g 2011-01-01T00:00:00Z |
| updated_before | - | Date | e.g 2011-01-01T00:00:00Z |
| agency_responsible | - | String | |
| extensions | - | Boolean | |

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
    <title>request.title</title>
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
    <title>request.title</title>
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
      <service_object_type/>
      <service_object_id/>
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
| title | X | String | Title (max. 300 character) |
| description | X | String | Description |
| lat | - | Float | either lat & long or address_string |
| long | - | Float | either lat & long or address_string |
| address_string | - | String | either address_string or lat & long |
| attribute | - | - | additional attributes |
| attribute[photo_required] | - | Boolean | Photo required |
| media | - | String | Photo |

Sample Response:

```xml
<request>
  <service_request_id>request.id</service_request_id>
</request>
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
| title | - | String | Title (max. 300 character) |
| description | - | String | Description |
| lat | - | Float | either lat & long or address_string |
| long | - | Float | either lat & long or address_string |
| address_string | - | String | either address_string or lat & long |
| attribute | - | - | additional attributes |
| attribute[photo_required] | - | Boolean | Photo required |
| attribute[status] | - | String | Status (RECEIVED, IN_PROCESS, PROCESSED, REJECTED) |
| attribute[status_comment] | - | String | Status comment |
| attribute[priority] | - | Integer | Priority |
| media | - | String | Photo |

Sample Response:

```xml

```

### Get Comments from Service Request
<code>http://[API endpoint]/requests/comments/[service_request_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  | Notes  |
|:--|:-:|:-:|:-:|
| service_request_id | X | Integer | |
| api_key | - | String | If ```api_key``` passed and ```read_comment_author``` permission is configured for given ```api_key``` the author will be displayed. |

Sample Response:

```xml
<comments type="array">
  <comment>
    <id>comment.id</id>
    <jurisdiction_id></jurisdiction_id>
    <comment>comment.text</comment>
    <datetime>comment.datetime</datetime>
    <service_request_id>comment.service_request_id</service_request_id>
    <author>comment.author</author>
  </comment>
</comments>
```

### Get Notes from Service Request
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
    <id>note.id</id>
    <jurisdiction_id></jurisdiction_id>
    <comment>note.text</comment>
    <datetime>note.datetime</datetime>
    <service_request_id>note.service_request_id</service_request_id>
    <author>note.author</author>
  </note>
</notes>
```

### Create new vote for Service Request
<code>http://[API endpoint]/requests/votes/[service_request_id].[format]</code>

HTTP Method: POST

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|
| service_request_id | X | Integer |
| api_key | X | String |
| email | X | String |

Sample Response:

```xml
<vote>
  <id>vote.id</id>
</vote>
```
