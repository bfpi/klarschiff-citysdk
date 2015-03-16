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

### GET Service Definition
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

### GET Service Requests (List)
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

### GET Service Request
<code>http://[API endpoint]/requests/[request_id].[format]</code>

HTTP Method: GET

Parameters:

| Name  | Required  | Type  |
|:--|:-:|:-:|:-:|
| service_request_id | X | Integer |
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
    <extended_attributes>
      <service_object_type/>
      <service_object_id/>
      <detailed_status>request.detailed_status</detailed_status>
      <media_urls>
        <media_url>request.media.url</media_url>
      </media_urls>
      <trust/>
      <votes/>
    </extended_attributes>
  </request>
</service_requests>
```
