UNIT uCockpitItsmApi;

// Cockpit ITSM public API - GENERATED UNIT, do not edit (regenerate with CIPAT4P)
// Source: Cockpit ITSM Portal - Public API 2026.8.4 - generated 2026-11-01 18:55
// Requires uCockpitItsmCore.pas (Delphi and Lazarus/FPC)
//
// Selected endpoints (read back by CIPAT4P when regenerating):
// @endpoint GET /api/infrastructure/equipment/{typeId}/{id} GetInfrastructureEquipment
// @endpoint GET /api/infrastructure/sap/system/{systemId} GetInfrastructureSapSystem
// @endpoint GET /api/monitoring/check/{id} GetMonitoringCheck
// @endpoint GET /api/organization/by-name GetOrganizationByName
// @endpoint GET /api/organization/list ListOrganization
// @endpoint GET /api/secured-data/{id} GetSecuredData
// @endpoint POST /api/configuration-parameters PostConfigurationParameters
// @endpoint POST /api/infrastructure/db/list ListInfrastructureDb
// @endpoint POST /api/infrastructure/relationships/list ListInfrastructureRelationships
// @endpoint POST /api/infrastructure/sap/list ListInfrastructureSap
// @endpoint POST /api/infrastructure/server/list ListInfrastructureServer
// @endpoint POST /api/monitoring/exceptional-maintenance-window PostMonitoringExceptionalMaintenanceWindow
// @endpoint POST /api/secured-data/{id}/decrypt PostSecuredDataDecrypt
// @endpoint POST /api/secured-data/list ListSecuredData
// @endpoint PUT /api/monitoring/exceptional-maintenance-window PutMonitoringExceptionalMaintenanceWindow

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

INTERFACE

USES
  {$IFDEF FPC}
  SysUtils, fpjson,
  {$ELSE}
  System.SysUtils, System.JSON,
  {$ENDIF}
  uCockpitItsmCore;

TYPE
  // An object reference (id and name)
  tyReferenceWithName = RECORD
    id: Int64; // ID of the reference target
    name: STRING; // [read-only] Name of the reference target
  END;
  tyReferenceWithNames = ARRAY OF tyReferenceWithName;

  // An object reference (id and description)
  tyReferenceWithDescription = RECORD
    description: STRING; // [read-only] Description of the reference target
    id: Int64; // ID of the reference target
  END;
  tyReferenceWithDescriptions = ARRAY OF tyReferenceWithDescription;

  tyTranslation = RECORD
    contact: STRING; // Translation for contacts
    id: Int64; // The translation ID
    language: STRING; // Language
    operator_: STRING; // Translation for operators
  END;
  tyTranslations = ARRAY OF tyTranslation;

  tySpecificProperty = RECORD
    id: Int64; // [read-only] Unique ID
    lastUpdateTimestamp: TDateTime; // [read-only] Timestamp of last update to this object
    lastUpdateUser: STRING; // [read-only] Author of last update to this object
    mandatory: Boolean; // Is this mandatory?
    numberOfItems: Integer; // [read-only] Number of items associated with this object. Read-only property only filled in in lists.
    options: tyReferenceWithDescriptions; // The associated options.
    reference: STRING; // The reference
    translations: tyTranslations; // The translations
  END;
  tySpecificPropertys = ARRAY OF tySpecificProperty;

  // Specific property on equipment
  tySpecificPropertyOnEquipment = RECORD
    id: Int64; // [read-only] Unique ID
    option: tyReferenceWithDescription; // The custom equipment property option
    property_: tySpecificProperty; // The custom equipment property
    propertyName: STRING; // The custom equipment property name (translated)
  END;
  tySpecificPropertyOnEquipments = ARRAY OF tySpecificPropertyOnEquipment;

  // An object reference (id and reference)
  tyReferenceWithReference = RECORD
    id: Int64; // ID of the reference target
    reference: STRING; // [read-only] Reference of the reference target
  END;
  tyReferenceWithReferences = ARRAY OF tyReferenceWithReference;

  tyNodeTypeSpecificFieldOption = RECORD
    id: Int64; // [read-only] ID
    value: STRING; // The name of the item menu
  END;
  tyNodeTypeSpecificFieldOptions = ARRAY OF tyNodeTypeSpecificFieldOption;

  // Node type specific field
  tyNodeTypeSpecificField = RECORD
    column: Integer; // The element column
    defaultDecimalValue: Double; // The default value of decimal field
    defaultIntegerValue: Integer; // The default value of integer field OR '2' for option 'Checked by default' (depends on s...
    defaultTextValue: STRING; // The default value of 1-line-text field
    fraction: Integer; // The element fraction. (number of column occupied, range 1-12)
    id: Int64; // [read-only] Unique ID
    mandatory: Boolean; // This flag controls whether the specific field represents a mandatory field, i.e. a valu...
    name: STRING; // The name of the specific field
    options: tyNodeTypeSpecificFieldOptions; // The combobox items
    row: Integer; // The element row
    type_: STRING; // The type of the specific field
  END;
  tyNodeTypeSpecificFields = ARRAY OF tyNodeTypeSpecificField;

  tyNodeTypeSpecificFieldLink = RECORD
    dateValue: TDateTime; // The specific field date value, if any
    decimalValue: Double; // The specific field decimal value, if any
    id: Int64; // [read-only] Unique ID
    intValue: Integer; // The specific field integer value, if any
    option: tyNodeTypeSpecificFieldOption; // The specific field option, if any
    specificField: tyNodeTypeSpecificField; // The specific field
    textValue: STRING; // The specific field text value, if any
  END;
  tyNodeTypeSpecificFieldLinks = ARRAY OF tyNodeTypeSpecificFieldLink;

  // Equipment data
  tyEquipment = RECORD
    accountingNotes: STRING; // Equipment accounting notes
    amortizationDoneAmount: Double; // [read-only] Equipment amortization done
    amortizationDuration: Integer; // Equipment amortization duration in years
    amortizationEnd: TDateTime; // [read-only] Equipment amortization end (without time and TZ)
    amortizationLast: TDateTime; // [read-only] Equipment last amortization (without time and TZ)
    amortizationStart: TDateTime; // Equipment amortization start (without time and TZ)
    amortizationToGoAmount: Double; // [read-only] Equipment amortization to go
    assetReference: STRING; // Equipment asset reference
    brand: STRING; // Equipment brand
    connectionTimeout: Int64; // Equipment connection timeout (in seconds). If not specified, the default timeout is used
    connectionType: STRING; // Equipment connection type
    dataCenter: tyReferenceWithName; // Equipment data center
    description: STRING; // Equipment description
    dnsName: STRING; // Equipment DNS name
    engineId: Int64; // Equipment engine ID
    environment: tyReferenceWithName; // Equipment environment
    externalReference: STRING; // Equipment external reference
    hostSystem: STRING; // Equipment ESX HostSystem
    id: Int64; // Equipment ID
    inventoryEnabled: Boolean; // Automated inventory enabled if supported for this system. Default value: false
    invoiceAmount: Double; // Equipment invoice amount
    invoiceDate: TDateTime; // Equipment invoice date (without time and TZ)
    invoiceReference: STRING; // Equipment invoice reference
    lastInventoryMessage: STRING; // [read-only] Message produced by latest inventory
    lastInventoryTimestamp: TDateTime; // [read-only] Timestamp of latest inventory
    lastInventoryUser: STRING; // [read-only] User who launched the latest inventory
    location: tyReferenceWithDescription; // Equipment location
    locationOption: STRING; // Node location option
    locationSite: tyReferenceWithDescription; // Equipment location site
    metricsEnabled: Boolean; // Metrics enabled? Default value: false
    model: STRING; // Equipment model
    monitoringEnabled: Boolean; // Monitoring enabled? Default value: true
    name: STRING; // Unique per organization
    notes: STRING; // Equipment notes
    numberOfOrganizations: Double;
    orderReference: STRING; // Equipment order reference
    organization: tyReferenceWithName; // Equipment organization
    organizationFilter: STRING; // Equipment organizations filter
    organizations: tyReferenceWithNames; // Organizations the equipment is shared with (ignored if structureFilter is NONE)
    os: STRING; // Equipment OS name (server only)
    password: STRING; // Username used to connect to the equipment (write-only property)
    port: Integer; // Equipment port
    rack: tyReferenceWithDescription; // Equipment rack
    relaxSsl: Boolean; // Relax SSL certificate checks (ESX connections). Default value: false
    serialNumber: STRING; // Equipment serial number
    snmpAuthPassphrase: STRING; // Equipment SNMP authentication passphrase (SNMP connections, write-only property)
    snmpAuthProtocol: STRING; // Equipment SNMP authentication protocol (SNMP connections)
    snmpAuthUsername: STRING; // Equipment SNMP authentication username (SNMP connections)
    snmpCommunity: STRING; // Equipment SNMP community (SNMP connections)
    snmpPort: Integer; // Equipment SNMP port (SNMP connections)
    snmpPrivacyPassphrase: STRING; // Equipment SNMP privacy passphrase (SNMP connections, write-only property)
    snmpPrivacyProtocol: STRING; // Equipment SNMP privacy protocol (SNMP connections)
    snmpVersion: Integer; // Equipment SNMP version (SNMP connections)
    specificProperties: tySpecificPropertyOnEquipments; // Equipment common and accounting specific properties
    sshKey: tyReferenceWithDescription; // Description of the SSH key used to connect (UNIX connections). Non-API object type: SSH...
    status: tyReferenceWithReference; // Equipment status reference
    subType: STRING; // Equipment sub-type, possible values: Server:[PHYSICAL, VIRTUAL], Storage:[DISK_ARRAY, A...
    supplier: tyReferenceWithName; // Equipment supplier
    tags: tyReferenceWithNames; // A list of tags associated to this equipment node
    technicalNotes: STRING; // Equipment technical notes
    type_: tyReferenceWithReference; // Equipment type reference (Server, Hci, Network, Storage or custom types)
    typeSpecificFields: tyNodeTypeSpecificFieldLinks; // The node type specific fields
    useHostSystem: Boolean; // Use the hostSystem field instead of dnsName to connect to an ESX system. Default value:...
    useSsl: Boolean; // Use SSL (WinRM connections). Default value: true
    username: STRING; // Username used to connect to the equipment
    uuid: STRING; // Equipment UUID
  END;
  tyEquipments = ARRAY OF tyEquipment;

  // An object reference (id, name and type)
  tyReferenceWithNameAndType = RECORD
    id: Int64; // ID of the reference target
    name: STRING; // [read-only] Name of the reference target
    type_: STRING; // Type of the reference target
  END;
  tyReferenceWithNameAndTypes = ARRAY OF tyReferenceWithNameAndType;

  // SAP system component
  tySapComponentData = RECORD
    description: STRING; // [read-only] SAP component description
    id: Int64; // [read-only] SAP component ID
    level: STRING; // [read-only] SAP component level
    name: STRING; // [read-only] SAP component name
    supportPackage: STRING; // [read-only] SAP component support package
    version: STRING; // [read-only] SAP component version
  END;
  tySapComponentDatas = ARRAY OF tySapComponentData;

  // SAP instance data
  tySapInstance = RECORD
    description: STRING; // [read-only] Formatted description
    equipment: tyReferenceWithNameAndType; // Equipment hosting this instance
    equipmentName: STRING; // Equipment name (cloud instance)
    id: Int64; // SAP instance ID
    javaCheckPort: Integer; // Java check port (Java instances only)
    javaPort: Integer; // Java port (Java instances only)
    system: tyReferenceWithDescription; // [read-only] SAP system
    systemNumber: STRING; // SAP system number
    type_: STRING; // Instance type
    useForInventory: Boolean; // Use this instance for automated inventory. Default value: false
    useForReports: Boolean; // Use this instance for automated report generation. Default value: false
  END;
  tySapInstances = ARRAY OF tySapInstance;

  // SAP system with info
  tySapSystemWithInfo = RECORD
    abapCentralService: tyReferenceWithNameAndType; // Equipment hosting ABAP central service
    abapLoadVersion: STRING; // [read-only] ABAP load version
    authClientId: STRING; // Authentication id
    authClientSecret: STRING; // Authentication secret
    authPassword: STRING; // Authentication password
    authPort: Integer; // Authentication port
    authUser: STRING; // Authentication user
    authenticationMode: STRING; // Authentication mode
    clientId: STRING; // SAP client ID
    components: tySapComponentDatas; // [read-only] List of SAP components
    componentsVersion: STRING; // [read-only] Components version
    cuaLoadVersion: STRING; // [read-only] CUA load version
    dbConnectionName: STRING; // DB connection name (DBCO).
    dbHost: STRING; // [read-only] DB host
    dbLibrary: STRING; // [read-only] DB library
    dbName: STRING; // [read-only] DB name
    dbOwner: STRING; // [read-only] DB owner
    dbRelease: STRING; // [read-only] DB release
    dbSize: STRING; // [read-only] DB size (Go)
    dbType: STRING; // [read-only] DB type
    description: STRING; // Unique per organization
    dialogUsersCount: STRING; // [read-only] Dialog users count
    engine: tyReferenceWithDescription; // Engine (cloud)
    environment: tyReferenceWithName; // Environment
    equipment: tyReferenceWithNameAndType; // Equipment hosting SCC (on premise)
    externalReference: STRING; // SAP System external reference
    fingerprint: STRING; // SSL certificate fingerprint
    id: Int64; // SAP system ID
    infrastructureMode: STRING; // Mode
    installationNumber: STRING; // [read-only] Installation number
    instances: tySapInstances; // SAP instances associated with the system (skipped in lists). If left not specified on U...
    inventoryEnabled: Boolean; // Automated inventory enabled
    javaCentralService: tyReferenceWithNameAndType; // Equipment hosting Java central service
    javaPassword: STRING; // Java password
    javaUsername: STRING; // Java username
    kernelCompiled: STRING; // [read-only] Kernel compiled
    kernelPatchLevel: STRING; // [read-only] Kernel patch level
    kernelRelease: STRING; // [read-only] Kernel release
    kind: STRING; // [read-only] Kind
    lastInventoryMessage: STRING; // [read-only] Message produced by latest inventory
    lastInventoryTimestamp: TDateTime; // [read-only] Timestamp of latest inventory
    lastInventoryUser: STRING; // [read-only] User who launched the latest inventory
    licenceExpiry: STRING; // [read-only] Licence expiry date
    logonGroup: STRING; // SAP logon group
    logonGroupEnabled: Boolean; // SAP logon group enabled
    logonGroupPort: Integer; // SAP logon group port
    monitoringEnabled: Boolean; // Monitoring enabled. Default value: true
    organization: tyReferenceWithName; // Organization
    password: STRING; // ABAP password
    region: STRING; // Region
    remarks: STRING; // Remarks
    router: STRING; // SAP router
    rsyn: STRING; // [read-only] Rsyn
    serverName: STRING; // Server name (cloud)
    sncEnabled: Boolean; // Enables/disables the use of Secured Network Communications (SNC)
    sncMyName: STRING; // Name of the secured network connection, that overrides the default secure network conne...
    sncPartnerName: STRING; // SNC name of the Application Server, that acts os the SNC partner
    sncSecurityLevel: STRING; // Security level of the secured network connections
    stackType: STRING; // Stack type
    supportedDatabases: STRING; // [read-only] Supported databases
    supportedSapVersions: STRING; // [read-only] Supported SAP versions
    systemId: STRING; // SAP system ID
    tags: tyReferenceWithNames; // A list of tags associated to this SAP system
    tenant: STRING; // Url tenant
    typeSpecificFields: tyNodeTypeSpecificFieldLinks; // The node type specific fields
    unicode: STRING; // [read-only] Unicode encoding?
    url: STRING; // Url
    username: STRING; // ABAP username
    uuid: STRING; // SAP System UUID
  END;
  tySapSystemWithInfos = ARRAY OF tySapSystemWithInfo;

  // Check threshold information
  tyThreshold = RECORD
    message: STRING; // [read-only] Threshold message
    notification: tyReferenceWithDescription; // [read-only] Threshold notification
    severity: STRING; // [read-only] Threshold severity
    team: tyReferenceWithName; // [read-only] Threshold team
  END;
  tyThresholds = ARRAY OF tyThreshold;

  // Alert log
  tyLog = RECORD
    details: TCockpitStrings; // [read-only] Details
    message: STRING; // [read-only] Alert message
    timestamp: TDateTime; // [read-only] Date/time of the alert
    value: STRING; // [read-only] Value
  END;
  tyLogs = ARRAY OF tyLog;

  // Check result
  tyCheckResult = RECORD
    date: TDateTime; // [read-only] Last occurrence of the alert
    logs: tyLogs; // [read-only] Alert logs attached to this alert message
    status: Integer; // [read-only] Error code (0: Success)
  END;
  tyCheckResults = ARRAY OF tyCheckResult;

  // Monitoring check information
  tyCheck = RECORD
    actionDocument: tyReferenceWithName; // [read-only] Check action document, if any
    applications: tyReferenceWithNames; // [read-only] Check applications
    checkId: Int64; // [read-only] Unique ID
    dependency: STRING; // [read-only] Description of the parent if any
    dependencyType: STRING; // [read-only] Execute on parent success / failure
    details: STRING; // [read-only] Check details
    displayCount: Integer; // [read-only] Alert display - Counter
    engine: tyReferenceWithDescription; // [read-only] Check engine
    environment: tyReferenceWithReference; // [read-only] Check environment
    equipment: tyReferenceWithName; // [read-only] Check equipment
    escalationDocument: tyReferenceWithName; // [read-only] Check escalation document, if any
    firstThreshold: tyThreshold; // [read-only] Check first threshold
    lastResult: tyCheckResult; // [read-only] Last alert message generated by this check
    lastUpdateTimestamp: TDateTime; // [read-only] Timestamp of last update to this object
    lastUpdateUser: STRING; // [read-only] Author of last update to this object
    notes: STRING; // [read-only] Check notes
    organization: tyReferenceWithName; // [read-only] Check organization (from it's equipment)
    parentId: Int64; // [read-only] ID of the parent check if any
    schedule: tyReferenceWithDescription; // [read-only] Check schedule
    secondThreshold: tyThreshold; // [read-only] Check second threshold, if any
    status: STRING; // [read-only] Status of the check
    subject: STRING; // [read-only] Check subject
    type_: STRING; // [read-only] Check type (translated)
  END;
  tyChecks = ARRAY OF tyCheck;

  // The organization data
  tyOrganization = RECORD
    autoAckExtremeAlerts: Boolean; // Activate auto-acknowledgment of extreme alerts in this organization
    autoAckHighAlerts: Boolean; // Activate auto-acknowledgment of high alerts in this organization
    autoAckInfoAlerts: Boolean; // Activate auto-acknowledgment of info alerts in this organization
    autoAckLowAlerts: Boolean; // Activate auto-acknowledgment of low alerts in this organization
    autoAckMediumAlerts: Boolean; // Activate auto-acknowledgment of medium alerts in this organization
    callsEnabled: Boolean; // Ticketing calls enabled for this organization
    changeRequestCatalog: tyReferenceWithName; // Ticket change requests catalog. Cannot be empty if changeRequestsEnabled is true
    changeRequestsEnabled: Boolean; // Ticket change requests enabled for this organization
    communicationModuleEnabled: Boolean; // Communication module enabled for this organization
    docModuleEnabled: Boolean; // Document module enabled for this organization
    enabled: Boolean; // The organization status (true if enabled)
    engineId: Int64; // Id of the default engine for this organization. Required if inventoryInfraEnabled is true
    id: Int64; // [read-only] Organization ID
    incidentCatalog: tyReferenceWithName; // Ticket incidents catalog. Cannot be empty if incidentsEnabled is true
    incidentsEnabled: Boolean; // Ticket incidents enabled for this organization
    inventoryInfraEnabled: Boolean; // Infrastructure menu enabled for this organization
    inventoryModuleEnabled: Boolean; // Inventory module enabled for this organization
    inventoryOfficeEnabled: Boolean; // Office menu enabled for this organization
    language: STRING; // Organization default language
    monitoringModuleEnabled: Boolean; // Monitoring module enabled for this organization
    name: STRING; // Name
    notes: STRING; // Organization notes
    passwordModuleEnabled: Boolean; // Password module enabled for this organization
    problemCatalog: tyReferenceWithName; // Ticket problem catalog. Cannot be empty if problemsEnabled is true
    problemsEnabled: Boolean; // Ticket problems enabled for this organization
    releaseCatalog: tyReferenceWithName; // Ticket release catalog. Cannot be empty if releasesEnabled is true
    releasesEnabled: Boolean; // Ticket releases enabled for this organization
    reportingModuleEnabled: Boolean; // Reporting module enabled for this organization
    requestCatalog: tyReferenceWithName; // Ticket requests catalog. Cannot be empty if requestsEnabled is true
    requestsEnabled: Boolean; // Ticket requests enabled for this organization
    teams: tyReferenceWithNames; // A list of teams that access this organization
    ticketMustBeCompletedAfterDays: Integer; // Number of days to wait before auto-archiving tickets for this organization
    ticketRating: STRING; // Ticket rating disabled/optional/mandatory for this organization
    ticketingModuleEnabled: Boolean; // Ticketing module enabled for this organization
    timeZone: STRING; // Organization default time zone ID
  END;
  tyOrganizations = ARRAY OF tyOrganization;

  // General information about an organization
  tyOrganizationSelection = RECORD
    communicationModuleEnabled: Boolean; // [read-only] Communication module enabled for this organization
    docModuleEnabled: Boolean; // [read-only] Document module enabled for this organization
    id: Int64; // ID of the reference target
    inventoryInfraEnabled: Boolean; // [read-only] Infrastructure menu enabled for this organization
    inventoryModuleEnabled: Boolean; // [read-only] Inventory module enabled for this organization
    inventoryOfficeEnabled: Boolean; // [read-only] Office menu enabled for this organization
    monitoringModuleEnabled: Boolean; // [read-only] Monitoring module enabled for this organization
    name: STRING; // [read-only] Name of the reference target
    passwordModuleEnabled: Boolean; // [read-only] Password module enabled for this organization
    reportingModuleEnabled: Boolean; // [read-only] Reporting module enabled for this organization
    ticketingModuleEnabled: Boolean; // [read-only] Ticketing module enabled for this organization
  END;
  tyOrganizationSelections = ARRAY OF tyOrganizationSelection;

  tyConfigurationParameter = RECORD
    data: STRING; // [read-only] The parameter data
    description: STRING; // [read-only] The parameter description
    id: Int64; // [read-only] The unique ID
    lastUpdateTimestamp: TDateTime; // [read-only] Last update date
    lastUpdateUser: STRING; // [read-only] Last update user
    value: STRING; // [read-only] The parameter value
  END;
  tyConfigurationParameters = ARRAY OF tyConfigurationParameter;

  // database data
  tyDatabase = RECORD
    id: Int64; // DB ID
    metricsEnabled: Boolean; // Metric enabled ?
    name: STRING; // DB name
    server: tyReferenceWithDescription; // [read-only] DB server (equipment)
  END;
  tyDatabases = ARRAY OF tyDatabase;

  // DB server data
  tyDatabaseServer = RECORD
    connectionOption: STRING; // Connection option
    connectionType: STRING; // Connection type
    databases: tyDatabases; // Databases on this server (skipped in lists). If not specified on UPDATE, the databases ...
    dbDriver: STRING; // DB driver
    description: STRING; // Unique per organization
    equipment: tyReferenceWithNameAndType; // Equipment
    externalReference: STRING; // Database external reference
    id: Int64; // DB server ID
    jdbcUrl: STRING; // JDBC URL
    metricsEnabled: Boolean; // Metrics enabled ?
    monitoringEnabled: Boolean; // Monitoring enabled ?
    organization: tyReferenceWithName; // Organization
    password: STRING; // Password
    port: Integer; // Port
    remarks: STRING; // Remarks
    typeSpecificFields: tyNodeTypeSpecificFieldLinks; // The node type specific fields
    username: STRING; // Username
    uuid: STRING; // Database UUID
  END;
  tyDatabaseServers = ARRAY OF tyDatabaseServer;

  tyEquipmentNodeSelection = RECORD
    connectionPossible: Boolean;
    description: STRING; // [read-only] Description
    environmentId: Int64; // [read-only] Environment ID
    environmentName: STRING; // [read-only] Environment name
    id: Int64; // Unique ID
    name: STRING; // [read-only] Name
    status: STRING; // [read-only] Status description
    structureId: Int64; // [read-only] Structure ID
    structureName: STRING; // [read-only] Structure name
    type_: STRING; // [read-only] Type reference
    typeDescription: STRING; // [read-only] Translated type
    typeId: Int64; // [read-only] The equipment type ID
  END;
  tyEquipmentNodeSelections = ARRAY OF tyEquipmentNodeSelection;

  tyConnection = RECORD
    downstreamNode: tyEquipmentNodeSelection; // Downstream node
    downstreamPortLabel: STRING; // Downstream port
    id: Int64; // Unique ID
    linkDescription: STRING; // Link description
    relation: STRING; // Relation description (upstream POV)
    upstreamNode: tyEquipmentNodeSelection; // Upstream node
    upstreamPortLabel: STRING; // Upstream port
  END;
  tyConnections = ARRAY OF tyConnection;

  // SAP System data
  tySapSystem = RECORD
    abapCentralService: tyReferenceWithNameAndType; // Equipment hosting ABAP central service
    authClientId: STRING; // Authentication id
    authClientSecret: STRING; // Authentication secret
    authPassword: STRING; // Authentication password
    authPort: Integer; // Authentication port
    authUser: STRING; // Authentication user
    authenticationMode: STRING; // Authentication mode
    clientId: STRING; // SAP client ID
    dbConnectionName: STRING; // DB connection name (DBCO).
    description: STRING; // Unique per organization
    engine: tyReferenceWithDescription; // Engine (cloud)
    environment: tyReferenceWithName; // Environment
    equipment: tyReferenceWithNameAndType; // Equipment hosting SCC (on premise)
    externalReference: STRING; // SAP System external reference
    fingerprint: STRING; // SSL certificate fingerprint
    id: Int64; // SAP system ID
    infrastructureMode: STRING; // Mode
    instances: tySapInstances; // SAP instances associated with the system (skipped in lists). If left not specified on U...
    inventoryEnabled: Boolean; // Automated inventory enabled
    javaCentralService: tyReferenceWithNameAndType; // Equipment hosting Java central service
    javaPassword: STRING; // Java password
    javaUsername: STRING; // Java username
    lastInventoryMessage: STRING; // [read-only] Message produced by latest inventory
    lastInventoryTimestamp: TDateTime; // [read-only] Timestamp of latest inventory
    lastInventoryUser: STRING; // [read-only] User who launched the latest inventory
    logonGroup: STRING; // SAP logon group
    logonGroupEnabled: Boolean; // SAP logon group enabled
    logonGroupPort: Integer; // SAP logon group port
    monitoringEnabled: Boolean; // Monitoring enabled. Default value: true
    organization: tyReferenceWithName; // Organization
    password: STRING; // ABAP password
    region: STRING; // Region
    remarks: STRING; // Remarks
    router: STRING; // SAP router
    serverName: STRING; // Server name (cloud)
    sncEnabled: Boolean; // Enables/disables the use of Secured Network Communications (SNC)
    sncMyName: STRING; // Name of the secured network connection, that overrides the default secure network conne...
    sncPartnerName: STRING; // SNC name of the Application Server, that acts os the SNC partner
    sncSecurityLevel: STRING; // Security level of the secured network connections
    stackType: STRING; // Stack type
    systemId: STRING; // SAP system ID
    tags: tyReferenceWithNames; // A list of tags associated to this SAP system
    tenant: STRING; // Url tenant
    typeSpecificFields: tyNodeTypeSpecificFieldLinks; // The node type specific fields
    url: STRING; // Url
    username: STRING; // ABAP username
    uuid: STRING; // SAP System UUID
  END;
  tySapSystems = ARRAY OF tySapSystem;

  // Maintenance window data
  tyMaintenanceWindowExceptional = RECORD
    checkIds: TCockpitInt64s; // Checks to disengage
    creationTimestamp: TDateTime; // [read-only] Timestamp of the object creation
    creationUser: STRING; // [read-only] User who created the object
    description: STRING; // Maintenance window description
    disengagementMode: STRING; // The mode of disengagement. Must be set to CHECKS if checkIds is not empty, NODES or NOD...
    endDate: TDateTime; // End date. The attribute "timezone" does *not* have an impact on the interpretation of t...
    hciIds: TCockpitInt64s; // Hci platforms to disengage
    id: Int64; // [read-only] Unique ID
    lastUpdateTimestamp: TDateTime; // [read-only] Timestamp of last update to this object
    lastUpdateUser: STRING; // [read-only] User who last updated the object
    networkIds: TCockpitInt64s; // Networks to disengage
    notes: STRING; // Notes
    organization: tyReferenceWithName; // The organization
    serverIds: TCockpitInt64s; // Servers to disengage
    serviceStatusImpact: STRING; // Services affected by this maintenance window
    services: tyReferenceWithNames; // Services affected by this maintenance window
    specificNodeIds: TCockpitInt64s; // Specific nodes to disengage
    startDate: TDateTime; // Start date. The attribute "timezone" does *not* have an impact on the interpretation of...
    storageIds: TCockpitInt64s; // Storages to disengage
    ticketIds: TCockpitInt64s; // The linked ticket Ids
    timeZone: STRING; // Time zone ID
  END;
  tyMaintenanceWindowExceptionals = ARRAY OF tyMaintenanceWindowExceptional;

  // SecuredData data
  tyPassword = RECORD
    apps: tyReferenceWithDescriptions; // [read-only] A list of apps this password is associated with (skipped in lists). Filled only when in...
    data: STRING; // The secure data additional data
    databases: tyReferenceWithDescriptions; // [read-only] A list of databases this password is associated with (skipped in lists). Filled only wh...
    description: STRING; // Description
    expirationDate: TDateTime; // Expiration date
    expirationNotificationDelay: Integer; // The number of days at which we send expiration notification (min: 1, max: 180)
    folder: tyReferenceWithName; // The folder this data belongs to
    hciPlatforms: tyReferenceWithNames; // [read-only] A list of hci platforms this password is associated with (skipped in lists). Filled onl...
    id: Int64; // ID
    networks: tyReferenceWithNames; // [read-only] A list of networks this password is associated with (skipped in lists). Filled only whe...
    officeEquipments: tyReferenceWithDescriptions; // [read-only] A list of office equipments this password is associated with (skipped in lists). Filled...
    organization: tyReferenceWithName; // Organization (obsolete)
    passphrase: STRING; // Passphrase (never displayed: write-only)
    passphraseProtected: Boolean; // [read-only] This flags indicates whether the password is protected by a passphrase
    password: STRING; // Password (never displayed: write-only)
    sapSystems: tyReferenceWithDescriptions; // [read-only] A list of SAP systems this password is associated with (skipped in lists). Filled only ...
    servers: tyReferenceWithNames; // [read-only] A list of servers this password is associated with (skipped in lists). Filled only when...
    specificNodes: tyReferenceWithNames; // [read-only] A list of specificNodes this password is associated with (skipped in lists). Filled onl...
    storage: tyReferenceWithNames; // [read-only] A list of storage this password is associated with (skipped in lists). Filled only when...
    type_: tyReferenceWithReference; // Non-API object type: PASSWORD_TYPE
    url: STRING; // URL
    username: STRING; // Username
    vault: tyReferenceWithName; // Non-API object type: VAULT_TYPE
  END;
  tyPasswords = ARRAY OF tyPassword;

  // Sort
  tySort = RECORD
    column: STRING; // Sort column
    dir: STRING; // Sort direction. Default value: ASC
  END;
  tySorts = ARRAY OF tySort;

  // The page request
  tyPageRequest = RECORD
    page: Integer; // Number of requested page
    pageSize: Integer; // Requested page size. Default value: 10 (empty value allowed)
    sort: tySorts; // The sort criteria to be used in this request
  END;
  tyPageRequests = ARRAY OF tyPageRequest;

  // The page request
  tyPageRequestWithSearch = RECORD
    pageRequest: tyPageRequest; // The page request
    query: STRING; // The search query
  END;
  tyPageRequestWithSearchs = ARRAY OF tyPageRequestWithSearch;

  // The page request
  tyList = RECORD
    pageRequestWithSearchBean: tyPageRequestWithSearch; // Page request with search
    tags: TCockpitStrings; // Restrict result to entries matching at least one of the given tags
  END;
  tyLists = ARRAY OF tyList;

  // Search parameters
  tySecuredDataList = RECORD
    appId: Int64; // List only secured data associated with the given app
    dbServerId: Int64; // List only secured data associated with the given DB server
    equipmentId: Int64; // List only secured data associated with the given office equipment
    folderId: Int64; // Restrict result to entries belonging to the given vault folder identified by its ID
    hciId: Int64; // List only secured data associated with the given hci
    networkId: Int64; // List only secured data associated with the given network
    organizationId: Int64; // Restrict result to entries belonging to the given organization identified by its ID
    pageRequestBean: tyPageRequest; // The page request
    sapId: Int64; // List only secured data associated with the given SAP system
    search: STRING; // Restrict result to entries whose description contains the given search term
    serverId: Int64; // List only secured data associated with the given server
    specificNodeId: Int64; // List only secured data associated with the given specific node
    storageId: Int64; // List only secured data associated with the given storage
    typeId: Int64; // The secured data type ID
    vaultId: Int64; // Restrict result to entries belonging to the given vault identified by its ID
  END;
  tySecuredDataLists = ARRAY OF tySecuredDataList;

  TCockpitItsmInstance = CLASS(TCockpitItsmBase)
  PUBLIC
    FUNCTION GetInfrastructureEquipment(ATypeId: Int64; AId: Int64): tyEquipment;
    // GET /api/infrastructure/equipment/{typeId}/{id}
    FUNCTION GetInfrastructureSapSystem(ASystemId: Int64): tySapSystemWithInfo;
    // GET /api/infrastructure/sap/system/{systemId}
    FUNCTION GetMonitoringCheck(AId: Int64): tyCheck;
    // GET /api/monitoring/check/{id}
    FUNCTION GetOrganizationByName(CONST AName: STRING): tyOrganization;
    // GET /api/organization/by-name
    FUNCTION ListOrganization: tyOrganizationSelections;
    // GET /api/organization/list
    FUNCTION GetSecuredData(AId: Int64): STRING;
    // GET /api/secured-data/{id}
    FUNCTION PostConfigurationParameters(CONST AItems: TCockpitIntegers): tyConfigurationParameters;
    // POST /api/configuration-parameters
    FUNCTION ListInfrastructureDb(AOrganizationId: Int64 = 0): tyDatabaseServers; OVERLOAD;
    FUNCTION ListInfrastructureDb(CONST ACriteria: tyPageRequestWithSearch; AOrganizationId: Int64 = 0): tyDatabaseServers; OVERLOAD;
    // POST /api/infrastructure/db/list (all pages)
    FUNCTION ListInfrastructureRelationships: tyConnections; OVERLOAD;
    FUNCTION ListInfrastructureRelationships(CONST ACriteria: tyPageRequestWithSearch): tyConnections; OVERLOAD;
    // POST /api/infrastructure/relationships/list (all pages)
    FUNCTION ListInfrastructureSap(AOrganizationId: Int64 = 0): tySapSystems; OVERLOAD;
    FUNCTION ListInfrastructureSap(CONST ACriteria: tyPageRequestWithSearch; AOrganizationId: Int64 = 0): tySapSystems; OVERLOAD;
    // POST /api/infrastructure/sap/list (all pages)
    FUNCTION ListInfrastructureServer(AOrganizationId: Int64 = 0): tyEquipments; OVERLOAD;
    FUNCTION ListInfrastructureServer(CONST ACriteria: tyList; AOrganizationId: Int64 = 0): tyEquipments; OVERLOAD;
    // POST /api/infrastructure/server/list (all pages)
    FUNCTION PostMonitoringExceptionalMaintenanceWindow(CONST AMaintenanceWindowExceptional: tyMaintenanceWindowExceptional): tyMaintenanceWindowExceptional;
    // POST /api/monitoring/exceptional-maintenance-window
    FUNCTION PostSecuredDataDecrypt(AId: Int64; CONST AText: STRING): STRING;
    // POST /api/secured-data/{id}/decrypt
    FUNCTION ListSecuredData: tyPasswords; OVERLOAD;
    FUNCTION ListSecuredData(CONST ACriteria: tySecuredDataList): tyPasswords; OVERLOAD;
    // POST /api/secured-data/list (all pages)
    FUNCTION PutMonitoringExceptionalMaintenanceWindow(CONST AMaintenanceWindowExceptional: tyMaintenanceWindowExceptional): tyMaintenanceWindowExceptional;
    // PUT /api/monitoring/exceptional-maintenance-window
  END;

// JSON <-> record conversions
FUNCTION JsonToReferenceWithName(AObj: TJSONObject): tyReferenceWithName;
FUNCTION JsonToReferenceWithNames(AArr: TJSONArray): tyReferenceWithNames;
FUNCTION ReferenceWithNameToJson(CONST ARec: tyReferenceWithName): TJSONObject;
FUNCTION ReferenceWithNamesToJson(CONST AArr: tyReferenceWithNames): TJSONArray;
FUNCTION JsonToReferenceWithDescription(AObj: TJSONObject): tyReferenceWithDescription;
FUNCTION JsonToReferenceWithDescriptions(AArr: TJSONArray): tyReferenceWithDescriptions;
FUNCTION JsonToTranslation(AObj: TJSONObject): tyTranslation;
FUNCTION JsonToTranslations(AArr: TJSONArray): tyTranslations;
FUNCTION JsonToSpecificProperty(AObj: TJSONObject): tySpecificProperty;
FUNCTION JsonToSpecificPropertys(AArr: TJSONArray): tySpecificPropertys;
FUNCTION JsonToSpecificPropertyOnEquipment(AObj: TJSONObject): tySpecificPropertyOnEquipment;
FUNCTION JsonToSpecificPropertyOnEquipments(AArr: TJSONArray): tySpecificPropertyOnEquipments;
FUNCTION JsonToReferenceWithReference(AObj: TJSONObject): tyReferenceWithReference;
FUNCTION JsonToReferenceWithReferences(AArr: TJSONArray): tyReferenceWithReferences;
FUNCTION JsonToNodeTypeSpecificFieldOption(AObj: TJSONObject): tyNodeTypeSpecificFieldOption;
FUNCTION JsonToNodeTypeSpecificFieldOptions(AArr: TJSONArray): tyNodeTypeSpecificFieldOptions;
FUNCTION JsonToNodeTypeSpecificField(AObj: TJSONObject): tyNodeTypeSpecificField;
FUNCTION JsonToNodeTypeSpecificFields(AArr: TJSONArray): tyNodeTypeSpecificFields;
FUNCTION JsonToNodeTypeSpecificFieldLink(AObj: TJSONObject): tyNodeTypeSpecificFieldLink;
FUNCTION JsonToNodeTypeSpecificFieldLinks(AArr: TJSONArray): tyNodeTypeSpecificFieldLinks;
FUNCTION JsonToEquipment(AObj: TJSONObject): tyEquipment;
FUNCTION JsonToEquipments(AArr: TJSONArray): tyEquipments;
FUNCTION JsonToReferenceWithNameAndType(AObj: TJSONObject): tyReferenceWithNameAndType;
FUNCTION JsonToReferenceWithNameAndTypes(AArr: TJSONArray): tyReferenceWithNameAndTypes;
FUNCTION JsonToSapComponentData(AObj: TJSONObject): tySapComponentData;
FUNCTION JsonToSapComponentDatas(AArr: TJSONArray): tySapComponentDatas;
FUNCTION JsonToSapInstance(AObj: TJSONObject): tySapInstance;
FUNCTION JsonToSapInstances(AArr: TJSONArray): tySapInstances;
FUNCTION JsonToSapSystemWithInfo(AObj: TJSONObject): tySapSystemWithInfo;
FUNCTION JsonToSapSystemWithInfos(AArr: TJSONArray): tySapSystemWithInfos;
FUNCTION JsonToThreshold(AObj: TJSONObject): tyThreshold;
FUNCTION JsonToThresholds(AArr: TJSONArray): tyThresholds;
FUNCTION JsonToLog(AObj: TJSONObject): tyLog;
FUNCTION JsonToLogs(AArr: TJSONArray): tyLogs;
FUNCTION JsonToCheckResult(AObj: TJSONObject): tyCheckResult;
FUNCTION JsonToCheckResults(AArr: TJSONArray): tyCheckResults;
FUNCTION JsonToCheck(AObj: TJSONObject): tyCheck;
FUNCTION JsonToChecks(AArr: TJSONArray): tyChecks;
FUNCTION JsonToOrganization(AObj: TJSONObject): tyOrganization;
FUNCTION JsonToOrganizations(AArr: TJSONArray): tyOrganizations;
FUNCTION JsonToOrganizationSelection(AObj: TJSONObject): tyOrganizationSelection;
FUNCTION JsonToOrganizationSelections(AArr: TJSONArray): tyOrganizationSelections;
FUNCTION JsonToConfigurationParameter(AObj: TJSONObject): tyConfigurationParameter;
FUNCTION JsonToConfigurationParameters(AArr: TJSONArray): tyConfigurationParameters;
FUNCTION JsonToDatabase(AObj: TJSONObject): tyDatabase;
FUNCTION JsonToDatabases(AArr: TJSONArray): tyDatabases;
FUNCTION JsonToDatabaseServer(AObj: TJSONObject): tyDatabaseServer;
FUNCTION JsonToDatabaseServers(AArr: TJSONArray): tyDatabaseServers;
FUNCTION JsonToEquipmentNodeSelection(AObj: TJSONObject): tyEquipmentNodeSelection;
FUNCTION JsonToEquipmentNodeSelections(AArr: TJSONArray): tyEquipmentNodeSelections;
FUNCTION JsonToConnection(AObj: TJSONObject): tyConnection;
FUNCTION JsonToConnections(AArr: TJSONArray): tyConnections;
FUNCTION JsonToSapSystem(AObj: TJSONObject): tySapSystem;
FUNCTION JsonToSapSystems(AArr: TJSONArray): tySapSystems;
FUNCTION JsonToMaintenanceWindowExceptional(AObj: TJSONObject): tyMaintenanceWindowExceptional;
FUNCTION JsonToMaintenanceWindowExceptionals(AArr: TJSONArray): tyMaintenanceWindowExceptionals;
FUNCTION MaintenanceWindowExceptionalToJson(CONST ARec: tyMaintenanceWindowExceptional): TJSONObject;
FUNCTION MaintenanceWindowExceptionalsToJson(CONST AArr: tyMaintenanceWindowExceptionals): TJSONArray;
FUNCTION JsonToPassword(AObj: TJSONObject): tyPassword;
FUNCTION JsonToPasswords(AArr: TJSONArray): tyPasswords;
FUNCTION SortToJson(CONST ARec: tySort): TJSONObject;
FUNCTION SortsToJson(CONST AArr: tySorts): TJSONArray;
FUNCTION PageRequestToJson(CONST ARec: tyPageRequest): TJSONObject;
FUNCTION PageRequestsToJson(CONST AArr: tyPageRequests): TJSONArray;
FUNCTION PageRequestWithSearchToJson(CONST ARec: tyPageRequestWithSearch): TJSONObject;
FUNCTION PageRequestWithSearchsToJson(CONST AArr: tyPageRequestWithSearchs): TJSONArray;
FUNCTION ListToJson(CONST ARec: tyList): TJSONObject;
FUNCTION ListsToJson(CONST AArr: tyLists): TJSONArray;
FUNCTION SecuredDataListToJson(CONST ARec: tySecuredDataList): TJSONObject;
FUNCTION SecuredDataListsToJson(CONST AArr: tySecuredDataLists): TJSONArray;

IMPLEMENTATION

FUNCTION JsonToReferenceWithName(AObj: TJSONObject): tyReferenceWithName;
BEGIN
  Result := Default(tyReferenceWithName);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.name := JStr(AObj, 'name');
END;

FUNCTION JsonToReferenceWithNames(AArr: TJSONArray): tyReferenceWithNames;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToReferenceWithName(JItemObj(AArr, I));
END;

FUNCTION ReferenceWithNameToJson(CONST ARec: tyReferenceWithName): TJSONObject;
BEGIN
  Result := JNewObj;
  JAddInt(Result, 'id', ARec.id);
END;

FUNCTION ReferenceWithNamesToJson(CONST AArr: tyReferenceWithNames): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, ReferenceWithNameToJson(AArr[I]));
END;

FUNCTION JsonToReferenceWithDescription(AObj: TJSONObject): tyReferenceWithDescription;
BEGIN
  Result := Default(tyReferenceWithDescription);
  IF AObj = NIL THEN
    Exit;
  Result.description := JStr(AObj, 'description');
  Result.id := JInt64(AObj, 'id');
END;

FUNCTION JsonToReferenceWithDescriptions(AArr: TJSONArray): tyReferenceWithDescriptions;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToReferenceWithDescription(JItemObj(AArr, I));
END;

FUNCTION JsonToTranslation(AObj: TJSONObject): tyTranslation;
BEGIN
  Result := Default(tyTranslation);
  IF AObj = NIL THEN
    Exit;
  Result.contact := JStr(AObj, 'contact');
  Result.id := JInt64(AObj, 'id');
  Result.language := JStr(AObj, 'language');
  Result.operator_ := JStr(AObj, 'operator');
END;

FUNCTION JsonToTranslations(AArr: TJSONArray): tyTranslations;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToTranslation(JItemObj(AArr, I));
END;

FUNCTION JsonToSpecificProperty(AObj: TJSONObject): tySpecificProperty;
BEGIN
  Result := Default(tySpecificProperty);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.lastUpdateTimestamp := JDate(AObj, 'lastUpdateTimestamp');
  Result.lastUpdateUser := JStr(AObj, 'lastUpdateUser');
  Result.mandatory := JBool(AObj, 'mandatory');
  Result.numberOfItems := JInt(AObj, 'numberOfItems');
  Result.options := JsonToReferenceWithDescriptions(JArr(AObj, 'options'));
  Result.reference := JStr(AObj, 'reference');
  Result.translations := JsonToTranslations(JArr(AObj, 'translations'));
END;

FUNCTION JsonToSpecificPropertys(AArr: TJSONArray): tySpecificPropertys;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSpecificProperty(JItemObj(AArr, I));
END;

FUNCTION JsonToSpecificPropertyOnEquipment(AObj: TJSONObject): tySpecificPropertyOnEquipment;
BEGIN
  Result := Default(tySpecificPropertyOnEquipment);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.option := JsonToReferenceWithDescription(JObj(AObj, 'option'));
  Result.property_ := JsonToSpecificProperty(JObj(AObj, 'property'));
  Result.propertyName := JStr(AObj, 'propertyName');
END;

FUNCTION JsonToSpecificPropertyOnEquipments(AArr: TJSONArray): tySpecificPropertyOnEquipments;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSpecificPropertyOnEquipment(JItemObj(AArr, I));
END;

FUNCTION JsonToReferenceWithReference(AObj: TJSONObject): tyReferenceWithReference;
BEGIN
  Result := Default(tyReferenceWithReference);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.reference := JStr(AObj, 'reference');
END;

FUNCTION JsonToReferenceWithReferences(AArr: TJSONArray): tyReferenceWithReferences;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToReferenceWithReference(JItemObj(AArr, I));
END;

FUNCTION JsonToNodeTypeSpecificFieldOption(AObj: TJSONObject): tyNodeTypeSpecificFieldOption;
BEGIN
  Result := Default(tyNodeTypeSpecificFieldOption);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.value := JStr(AObj, 'value');
END;

FUNCTION JsonToNodeTypeSpecificFieldOptions(AArr: TJSONArray): tyNodeTypeSpecificFieldOptions;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToNodeTypeSpecificFieldOption(JItemObj(AArr, I));
END;

FUNCTION JsonToNodeTypeSpecificField(AObj: TJSONObject): tyNodeTypeSpecificField;
BEGIN
  Result := Default(tyNodeTypeSpecificField);
  IF AObj = NIL THEN
    Exit;
  Result.column := JInt(AObj, 'column');
  Result.defaultDecimalValue := JFloat(AObj, 'defaultDecimalValue');
  Result.defaultIntegerValue := JInt(AObj, 'defaultIntegerValue');
  Result.defaultTextValue := JStr(AObj, 'defaultTextValue');
  Result.fraction := JInt(AObj, 'fraction');
  Result.id := JInt64(AObj, 'id');
  Result.mandatory := JBool(AObj, 'mandatory');
  Result.name := JStr(AObj, 'name');
  Result.options := JsonToNodeTypeSpecificFieldOptions(JArr(AObj, 'options'));
  Result.row := JInt(AObj, 'row');
  Result.type_ := JStr(AObj, 'type');
END;

FUNCTION JsonToNodeTypeSpecificFields(AArr: TJSONArray): tyNodeTypeSpecificFields;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToNodeTypeSpecificField(JItemObj(AArr, I));
END;

FUNCTION JsonToNodeTypeSpecificFieldLink(AObj: TJSONObject): tyNodeTypeSpecificFieldLink;
BEGIN
  Result := Default(tyNodeTypeSpecificFieldLink);
  IF AObj = NIL THEN
    Exit;
  Result.dateValue := JDate(AObj, 'dateValue');
  Result.decimalValue := JFloat(AObj, 'decimalValue');
  Result.id := JInt64(AObj, 'id');
  Result.intValue := JInt(AObj, 'intValue');
  Result.option := JsonToNodeTypeSpecificFieldOption(JObj(AObj, 'option'));
  Result.specificField := JsonToNodeTypeSpecificField(JObj(AObj, 'specificField'));
  Result.textValue := JStr(AObj, 'textValue');
END;

FUNCTION JsonToNodeTypeSpecificFieldLinks(AArr: TJSONArray): tyNodeTypeSpecificFieldLinks;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToNodeTypeSpecificFieldLink(JItemObj(AArr, I));
END;

FUNCTION JsonToEquipment(AObj: TJSONObject): tyEquipment;
BEGIN
  Result := Default(tyEquipment);
  IF AObj = NIL THEN
    Exit;
  Result.accountingNotes := JStr(AObj, 'accountingNotes');
  Result.amortizationDoneAmount := JFloat(AObj, 'amortizationDoneAmount');
  Result.amortizationDuration := JInt(AObj, 'amortizationDuration');
  Result.amortizationEnd := JDate(AObj, 'amortizationEnd');
  Result.amortizationLast := JDate(AObj, 'amortizationLast');
  Result.amortizationStart := JDate(AObj, 'amortizationStart');
  Result.amortizationToGoAmount := JFloat(AObj, 'amortizationToGoAmount');
  Result.assetReference := JStr(AObj, 'assetReference');
  Result.brand := JStr(AObj, 'brand');
  Result.connectionTimeout := JInt64(AObj, 'connectionTimeout');
  Result.connectionType := JStr(AObj, 'connectionType');
  Result.dataCenter := JsonToReferenceWithName(JObj(AObj, 'dataCenter'));
  Result.description := JStr(AObj, 'description');
  Result.dnsName := JStr(AObj, 'dnsName');
  Result.engineId := JInt64(AObj, 'engineId');
  Result.environment := JsonToReferenceWithName(JObj(AObj, 'environment'));
  Result.externalReference := JStr(AObj, 'externalReference');
  Result.hostSystem := JStr(AObj, 'hostSystem');
  Result.id := JInt64(AObj, 'id');
  Result.inventoryEnabled := JBool(AObj, 'inventoryEnabled');
  Result.invoiceAmount := JFloat(AObj, 'invoiceAmount');
  Result.invoiceDate := JDate(AObj, 'invoiceDate');
  Result.invoiceReference := JStr(AObj, 'invoiceReference');
  Result.lastInventoryMessage := JStr(AObj, 'lastInventoryMessage');
  Result.lastInventoryTimestamp := JDate(AObj, 'lastInventoryTimestamp');
  Result.lastInventoryUser := JStr(AObj, 'lastInventoryUser');
  Result.location := JsonToReferenceWithDescription(JObj(AObj, 'location'));
  Result.locationOption := JStr(AObj, 'locationOption');
  Result.locationSite := JsonToReferenceWithDescription(JObj(AObj, 'locationSite'));
  Result.metricsEnabled := JBool(AObj, 'metricsEnabled');
  Result.model := JStr(AObj, 'model');
  Result.monitoringEnabled := JBool(AObj, 'monitoringEnabled');
  Result.name := JStr(AObj, 'name');
  Result.notes := JStr(AObj, 'notes');
  Result.numberOfOrganizations := JFloat(AObj, 'numberOfOrganizations');
  Result.orderReference := JStr(AObj, 'orderReference');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.organizationFilter := JStr(AObj, 'organizationFilter');
  Result.organizations := JsonToReferenceWithNames(JArr(AObj, 'organizations'));
  Result.os := JStr(AObj, 'os');
  Result.password := JStr(AObj, 'password');
  Result.port := JInt(AObj, 'port');
  Result.rack := JsonToReferenceWithDescription(JObj(AObj, 'rack'));
  Result.relaxSsl := JBool(AObj, 'relaxSsl');
  Result.serialNumber := JStr(AObj, 'serialNumber');
  Result.snmpAuthPassphrase := JStr(AObj, 'snmpAuthPassphrase');
  Result.snmpAuthProtocol := JStr(AObj, 'snmpAuthProtocol');
  Result.snmpAuthUsername := JStr(AObj, 'snmpAuthUsername');
  Result.snmpCommunity := JStr(AObj, 'snmpCommunity');
  Result.snmpPort := JInt(AObj, 'snmpPort');
  Result.snmpPrivacyPassphrase := JStr(AObj, 'snmpPrivacyPassphrase');
  Result.snmpPrivacyProtocol := JStr(AObj, 'snmpPrivacyProtocol');
  Result.snmpVersion := JInt(AObj, 'snmpVersion');
  Result.specificProperties := JsonToSpecificPropertyOnEquipments(JArr(AObj, 'specificProperties'));
  Result.sshKey := JsonToReferenceWithDescription(JObj(AObj, 'sshKey'));
  Result.status := JsonToReferenceWithReference(JObj(AObj, 'status'));
  Result.subType := JStr(AObj, 'subType');
  Result.supplier := JsonToReferenceWithName(JObj(AObj, 'supplier'));
  Result.tags := JsonToReferenceWithNames(JArr(AObj, 'tags'));
  Result.technicalNotes := JStr(AObj, 'technicalNotes');
  Result.type_ := JsonToReferenceWithReference(JObj(AObj, 'type'));
  Result.typeSpecificFields := JsonToNodeTypeSpecificFieldLinks(JArr(AObj, 'typeSpecificFields'));
  Result.useHostSystem := JBool(AObj, 'useHostSystem');
  Result.useSsl := JBool(AObj, 'useSsl');
  Result.username := JStr(AObj, 'username');
  Result.uuid := JStr(AObj, 'uuid');
END;

FUNCTION JsonToEquipments(AArr: TJSONArray): tyEquipments;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToEquipment(JItemObj(AArr, I));
END;

FUNCTION JsonToReferenceWithNameAndType(AObj: TJSONObject): tyReferenceWithNameAndType;
BEGIN
  Result := Default(tyReferenceWithNameAndType);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.name := JStr(AObj, 'name');
  Result.type_ := JStr(AObj, 'type');
END;

FUNCTION JsonToReferenceWithNameAndTypes(AArr: TJSONArray): tyReferenceWithNameAndTypes;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToReferenceWithNameAndType(JItemObj(AArr, I));
END;

FUNCTION JsonToSapComponentData(AObj: TJSONObject): tySapComponentData;
BEGIN
  Result := Default(tySapComponentData);
  IF AObj = NIL THEN
    Exit;
  Result.description := JStr(AObj, 'description');
  Result.id := JInt64(AObj, 'id');
  Result.level := JStr(AObj, 'level');
  Result.name := JStr(AObj, 'name');
  Result.supportPackage := JStr(AObj, 'supportPackage');
  Result.version := JStr(AObj, 'version');
END;

FUNCTION JsonToSapComponentDatas(AArr: TJSONArray): tySapComponentDatas;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSapComponentData(JItemObj(AArr, I));
END;

FUNCTION JsonToSapInstance(AObj: TJSONObject): tySapInstance;
BEGIN
  Result := Default(tySapInstance);
  IF AObj = NIL THEN
    Exit;
  Result.description := JStr(AObj, 'description');
  Result.equipment := JsonToReferenceWithNameAndType(JObj(AObj, 'equipment'));
  Result.equipmentName := JStr(AObj, 'equipmentName');
  Result.id := JInt64(AObj, 'id');
  Result.javaCheckPort := JInt(AObj, 'javaCheckPort');
  Result.javaPort := JInt(AObj, 'javaPort');
  Result.system := JsonToReferenceWithDescription(JObj(AObj, 'system'));
  Result.systemNumber := JStr(AObj, 'systemNumber');
  Result.type_ := JStr(AObj, 'type');
  Result.useForInventory := JBool(AObj, 'useForInventory');
  Result.useForReports := JBool(AObj, 'useForReports');
END;

FUNCTION JsonToSapInstances(AArr: TJSONArray): tySapInstances;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSapInstance(JItemObj(AArr, I));
END;

FUNCTION JsonToSapSystemWithInfo(AObj: TJSONObject): tySapSystemWithInfo;
BEGIN
  Result := Default(tySapSystemWithInfo);
  IF AObj = NIL THEN
    Exit;
  Result.abapCentralService := JsonToReferenceWithNameAndType(JObj(AObj, 'abapCentralService'));
  Result.abapLoadVersion := JStr(AObj, 'abapLoadVersion');
  Result.authClientId := JStr(AObj, 'authClientId');
  Result.authClientSecret := JStr(AObj, 'authClientSecret');
  Result.authPassword := JStr(AObj, 'authPassword');
  Result.authPort := JInt(AObj, 'authPort');
  Result.authUser := JStr(AObj, 'authUser');
  Result.authenticationMode := JStr(AObj, 'authenticationMode');
  Result.clientId := JStr(AObj, 'clientId');
  Result.components := JsonToSapComponentDatas(JArr(AObj, 'components'));
  Result.componentsVersion := JStr(AObj, 'componentsVersion');
  Result.cuaLoadVersion := JStr(AObj, 'cuaLoadVersion');
  Result.dbConnectionName := JStr(AObj, 'dbConnectionName');
  Result.dbHost := JStr(AObj, 'dbHost');
  Result.dbLibrary := JStr(AObj, 'dbLibrary');
  Result.dbName := JStr(AObj, 'dbName');
  Result.dbOwner := JStr(AObj, 'dbOwner');
  Result.dbRelease := JStr(AObj, 'dbRelease');
  Result.dbSize := JStr(AObj, 'dbSize');
  Result.dbType := JStr(AObj, 'dbType');
  Result.description := JStr(AObj, 'description');
  Result.dialogUsersCount := JStr(AObj, 'dialogUsersCount');
  Result.engine := JsonToReferenceWithDescription(JObj(AObj, 'engine'));
  Result.environment := JsonToReferenceWithName(JObj(AObj, 'environment'));
  Result.equipment := JsonToReferenceWithNameAndType(JObj(AObj, 'equipment'));
  Result.externalReference := JStr(AObj, 'externalReference');
  Result.fingerprint := JStr(AObj, 'fingerprint');
  Result.id := JInt64(AObj, 'id');
  Result.infrastructureMode := JStr(AObj, 'infrastructureMode');
  Result.installationNumber := JStr(AObj, 'installationNumber');
  Result.instances := JsonToSapInstances(JArr(AObj, 'instances'));
  Result.inventoryEnabled := JBool(AObj, 'inventoryEnabled');
  Result.javaCentralService := JsonToReferenceWithNameAndType(JObj(AObj, 'javaCentralService'));
  Result.javaPassword := JStr(AObj, 'javaPassword');
  Result.javaUsername := JStr(AObj, 'javaUsername');
  Result.kernelCompiled := JStr(AObj, 'kernelCompiled');
  Result.kernelPatchLevel := JStr(AObj, 'kernelPatchLevel');
  Result.kernelRelease := JStr(AObj, 'kernelRelease');
  Result.kind := JStr(AObj, 'kind');
  Result.lastInventoryMessage := JStr(AObj, 'lastInventoryMessage');
  Result.lastInventoryTimestamp := JDate(AObj, 'lastInventoryTimestamp');
  Result.lastInventoryUser := JStr(AObj, 'lastInventoryUser');
  Result.licenceExpiry := JStr(AObj, 'licenceExpiry');
  Result.logonGroup := JStr(AObj, 'logonGroup');
  Result.logonGroupEnabled := JBool(AObj, 'logonGroupEnabled');
  Result.logonGroupPort := JInt(AObj, 'logonGroupPort');
  Result.monitoringEnabled := JBool(AObj, 'monitoringEnabled');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.password := JStr(AObj, 'password');
  Result.region := JStr(AObj, 'region');
  Result.remarks := JStr(AObj, 'remarks');
  Result.router := JStr(AObj, 'router');
  Result.rsyn := JStr(AObj, 'rsyn');
  Result.serverName := JStr(AObj, 'serverName');
  Result.sncEnabled := JBool(AObj, 'sncEnabled');
  Result.sncMyName := JStr(AObj, 'sncMyName');
  Result.sncPartnerName := JStr(AObj, 'sncPartnerName');
  Result.sncSecurityLevel := JStr(AObj, 'sncSecurityLevel');
  Result.stackType := JStr(AObj, 'stackType');
  Result.supportedDatabases := JStr(AObj, 'supportedDatabases');
  Result.supportedSapVersions := JStr(AObj, 'supportedSapVersions');
  Result.systemId := JStr(AObj, 'systemId');
  Result.tags := JsonToReferenceWithNames(JArr(AObj, 'tags'));
  Result.tenant := JStr(AObj, 'tenant');
  Result.typeSpecificFields := JsonToNodeTypeSpecificFieldLinks(JArr(AObj, 'typeSpecificFields'));
  Result.unicode := JStr(AObj, 'unicode');
  Result.url := JStr(AObj, 'url');
  Result.username := JStr(AObj, 'username');
  Result.uuid := JStr(AObj, 'uuid');
END;

FUNCTION JsonToSapSystemWithInfos(AArr: TJSONArray): tySapSystemWithInfos;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSapSystemWithInfo(JItemObj(AArr, I));
END;

FUNCTION JsonToThreshold(AObj: TJSONObject): tyThreshold;
BEGIN
  Result := Default(tyThreshold);
  IF AObj = NIL THEN
    Exit;
  Result.message := JStr(AObj, 'message');
  Result.notification := JsonToReferenceWithDescription(JObj(AObj, 'notification'));
  Result.severity := JStr(AObj, 'severity');
  Result.team := JsonToReferenceWithName(JObj(AObj, 'team'));
END;

FUNCTION JsonToThresholds(AArr: TJSONArray): tyThresholds;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToThreshold(JItemObj(AArr, I));
END;

FUNCTION JsonToLog(AObj: TJSONObject): tyLog;
BEGIN
  Result := Default(tyLog);
  IF AObj = NIL THEN
    Exit;
  Result.details := JArrToStrs(JArr(AObj, 'details'));
  Result.message := JStr(AObj, 'message');
  Result.timestamp := JDate(AObj, 'timestamp');
  Result.value := JRaw(AObj, 'value');
END;

FUNCTION JsonToLogs(AArr: TJSONArray): tyLogs;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToLog(JItemObj(AArr, I));
END;

FUNCTION JsonToCheckResult(AObj: TJSONObject): tyCheckResult;
BEGIN
  Result := Default(tyCheckResult);
  IF AObj = NIL THEN
    Exit;
  Result.date := JDate(AObj, 'date');
  Result.logs := JsonToLogs(JArr(AObj, 'logs'));
  Result.status := JInt(AObj, 'status');
END;

FUNCTION JsonToCheckResults(AArr: TJSONArray): tyCheckResults;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToCheckResult(JItemObj(AArr, I));
END;

FUNCTION JsonToCheck(AObj: TJSONObject): tyCheck;
BEGIN
  Result := Default(tyCheck);
  IF AObj = NIL THEN
    Exit;
  Result.actionDocument := JsonToReferenceWithName(JObj(AObj, 'actionDocument'));
  Result.applications := JsonToReferenceWithNames(JArr(AObj, 'applications'));
  Result.checkId := JInt64(AObj, 'checkId');
  Result.dependency := JStr(AObj, 'dependency');
  Result.dependencyType := JStr(AObj, 'dependencyType');
  Result.details := JStr(AObj, 'details');
  Result.displayCount := JInt(AObj, 'displayCount');
  Result.engine := JsonToReferenceWithDescription(JObj(AObj, 'engine'));
  Result.environment := JsonToReferenceWithReference(JObj(AObj, 'environment'));
  Result.equipment := JsonToReferenceWithName(JObj(AObj, 'equipment'));
  Result.escalationDocument := JsonToReferenceWithName(JObj(AObj, 'escalationDocument'));
  Result.firstThreshold := JsonToThreshold(JObj(AObj, 'firstThreshold'));
  Result.lastResult := JsonToCheckResult(JObj(AObj, 'lastResult'));
  Result.lastUpdateTimestamp := JDate(AObj, 'lastUpdateTimestamp');
  Result.lastUpdateUser := JStr(AObj, 'lastUpdateUser');
  Result.notes := JStr(AObj, 'notes');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.parentId := JInt64(AObj, 'parentId');
  Result.schedule := JsonToReferenceWithDescription(JObj(AObj, 'schedule'));
  Result.secondThreshold := JsonToThreshold(JObj(AObj, 'secondThreshold'));
  Result.status := JStr(AObj, 'status');
  Result.subject := JStr(AObj, 'subject');
  Result.type_ := JStr(AObj, 'type');
END;

FUNCTION JsonToChecks(AArr: TJSONArray): tyChecks;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToCheck(JItemObj(AArr, I));
END;

FUNCTION JsonToOrganization(AObj: TJSONObject): tyOrganization;
BEGIN
  Result := Default(tyOrganization);
  IF AObj = NIL THEN
    Exit;
  Result.autoAckExtremeAlerts := JBool(AObj, 'autoAckExtremeAlerts');
  Result.autoAckHighAlerts := JBool(AObj, 'autoAckHighAlerts');
  Result.autoAckInfoAlerts := JBool(AObj, 'autoAckInfoAlerts');
  Result.autoAckLowAlerts := JBool(AObj, 'autoAckLowAlerts');
  Result.autoAckMediumAlerts := JBool(AObj, 'autoAckMediumAlerts');
  Result.callsEnabled := JBool(AObj, 'callsEnabled');
  Result.changeRequestCatalog := JsonToReferenceWithName(JObj(AObj, 'changeRequestCatalog'));
  Result.changeRequestsEnabled := JBool(AObj, 'changeRequestsEnabled');
  Result.communicationModuleEnabled := JBool(AObj, 'communicationModuleEnabled');
  Result.docModuleEnabled := JBool(AObj, 'docModuleEnabled');
  Result.enabled := JBool(AObj, 'enabled');
  Result.engineId := JInt64(AObj, 'engineId');
  Result.id := JInt64(AObj, 'id');
  Result.incidentCatalog := JsonToReferenceWithName(JObj(AObj, 'incidentCatalog'));
  Result.incidentsEnabled := JBool(AObj, 'incidentsEnabled');
  Result.inventoryInfraEnabled := JBool(AObj, 'inventoryInfraEnabled');
  Result.inventoryModuleEnabled := JBool(AObj, 'inventoryModuleEnabled');
  Result.inventoryOfficeEnabled := JBool(AObj, 'inventoryOfficeEnabled');
  Result.language := JStr(AObj, 'language');
  Result.monitoringModuleEnabled := JBool(AObj, 'monitoringModuleEnabled');
  Result.name := JStr(AObj, 'name');
  Result.notes := JStr(AObj, 'notes');
  Result.passwordModuleEnabled := JBool(AObj, 'passwordModuleEnabled');
  Result.problemCatalog := JsonToReferenceWithName(JObj(AObj, 'problemCatalog'));
  Result.problemsEnabled := JBool(AObj, 'problemsEnabled');
  Result.releaseCatalog := JsonToReferenceWithName(JObj(AObj, 'releaseCatalog'));
  Result.releasesEnabled := JBool(AObj, 'releasesEnabled');
  Result.reportingModuleEnabled := JBool(AObj, 'reportingModuleEnabled');
  Result.requestCatalog := JsonToReferenceWithName(JObj(AObj, 'requestCatalog'));
  Result.requestsEnabled := JBool(AObj, 'requestsEnabled');
  Result.teams := JsonToReferenceWithNames(JArr(AObj, 'teams'));
  Result.ticketMustBeCompletedAfterDays := JInt(AObj, 'ticketMustBeCompletedAfterDays');
  Result.ticketRating := JStr(AObj, 'ticketRating');
  Result.ticketingModuleEnabled := JBool(AObj, 'ticketingModuleEnabled');
  Result.timeZone := JStr(AObj, 'timeZone');
END;

FUNCTION JsonToOrganizations(AArr: TJSONArray): tyOrganizations;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToOrganization(JItemObj(AArr, I));
END;

FUNCTION JsonToOrganizationSelection(AObj: TJSONObject): tyOrganizationSelection;
BEGIN
  Result := Default(tyOrganizationSelection);
  IF AObj = NIL THEN
    Exit;
  Result.communicationModuleEnabled := JBool(AObj, 'communicationModuleEnabled');
  Result.docModuleEnabled := JBool(AObj, 'docModuleEnabled');
  Result.id := JInt64(AObj, 'id');
  Result.inventoryInfraEnabled := JBool(AObj, 'inventoryInfraEnabled');
  Result.inventoryModuleEnabled := JBool(AObj, 'inventoryModuleEnabled');
  Result.inventoryOfficeEnabled := JBool(AObj, 'inventoryOfficeEnabled');
  Result.monitoringModuleEnabled := JBool(AObj, 'monitoringModuleEnabled');
  Result.name := JStr(AObj, 'name');
  Result.passwordModuleEnabled := JBool(AObj, 'passwordModuleEnabled');
  Result.reportingModuleEnabled := JBool(AObj, 'reportingModuleEnabled');
  Result.ticketingModuleEnabled := JBool(AObj, 'ticketingModuleEnabled');
END;

FUNCTION JsonToOrganizationSelections(AArr: TJSONArray): tyOrganizationSelections;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToOrganizationSelection(JItemObj(AArr, I));
END;

FUNCTION JsonToConfigurationParameter(AObj: TJSONObject): tyConfigurationParameter;
BEGIN
  Result := Default(tyConfigurationParameter);
  IF AObj = NIL THEN
    Exit;
  Result.data := JStr(AObj, 'data');
  Result.description := JStr(AObj, 'description');
  Result.id := JInt64(AObj, 'id');
  Result.lastUpdateTimestamp := JDate(AObj, 'lastUpdateTimestamp');
  Result.lastUpdateUser := JStr(AObj, 'lastUpdateUser');
  Result.value := JStr(AObj, 'value');
END;

FUNCTION JsonToConfigurationParameters(AArr: TJSONArray): tyConfigurationParameters;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToConfigurationParameter(JItemObj(AArr, I));
END;

FUNCTION JsonToDatabase(AObj: TJSONObject): tyDatabase;
BEGIN
  Result := Default(tyDatabase);
  IF AObj = NIL THEN
    Exit;
  Result.id := JInt64(AObj, 'id');
  Result.metricsEnabled := JBool(AObj, 'metricsEnabled');
  Result.name := JStr(AObj, 'name');
  Result.server := JsonToReferenceWithDescription(JObj(AObj, 'server'));
END;

FUNCTION JsonToDatabases(AArr: TJSONArray): tyDatabases;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToDatabase(JItemObj(AArr, I));
END;

FUNCTION JsonToDatabaseServer(AObj: TJSONObject): tyDatabaseServer;
BEGIN
  Result := Default(tyDatabaseServer);
  IF AObj = NIL THEN
    Exit;
  Result.connectionOption := JStr(AObj, 'connectionOption');
  Result.connectionType := JStr(AObj, 'connectionType');
  Result.databases := JsonToDatabases(JArr(AObj, 'databases'));
  Result.dbDriver := JStr(AObj, 'dbDriver');
  Result.description := JStr(AObj, 'description');
  Result.equipment := JsonToReferenceWithNameAndType(JObj(AObj, 'equipment'));
  Result.externalReference := JStr(AObj, 'externalReference');
  Result.id := JInt64(AObj, 'id');
  Result.jdbcUrl := JStr(AObj, 'jdbcUrl');
  Result.metricsEnabled := JBool(AObj, 'metricsEnabled');
  Result.monitoringEnabled := JBool(AObj, 'monitoringEnabled');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.password := JStr(AObj, 'password');
  Result.port := JInt(AObj, 'port');
  Result.remarks := JStr(AObj, 'remarks');
  Result.typeSpecificFields := JsonToNodeTypeSpecificFieldLinks(JArr(AObj, 'typeSpecificFields'));
  Result.username := JStr(AObj, 'username');
  Result.uuid := JStr(AObj, 'uuid');
END;

FUNCTION JsonToDatabaseServers(AArr: TJSONArray): tyDatabaseServers;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToDatabaseServer(JItemObj(AArr, I));
END;

FUNCTION JsonToEquipmentNodeSelection(AObj: TJSONObject): tyEquipmentNodeSelection;
BEGIN
  Result := Default(tyEquipmentNodeSelection);
  IF AObj = NIL THEN
    Exit;
  Result.connectionPossible := JBool(AObj, 'connectionPossible');
  Result.description := JStr(AObj, 'description');
  Result.environmentId := JInt64(AObj, 'environmentId');
  Result.environmentName := JStr(AObj, 'environmentName');
  Result.id := JInt64(AObj, 'id');
  Result.name := JStr(AObj, 'name');
  Result.status := JStr(AObj, 'status');
  Result.structureId := JInt64(AObj, 'structureId');
  Result.structureName := JStr(AObj, 'structureName');
  Result.type_ := JStr(AObj, 'type');
  Result.typeDescription := JStr(AObj, 'typeDescription');
  Result.typeId := JInt64(AObj, 'typeId');
END;

FUNCTION JsonToEquipmentNodeSelections(AArr: TJSONArray): tyEquipmentNodeSelections;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToEquipmentNodeSelection(JItemObj(AArr, I));
END;

FUNCTION JsonToConnection(AObj: TJSONObject): tyConnection;
BEGIN
  Result := Default(tyConnection);
  IF AObj = NIL THEN
    Exit;
  Result.downstreamNode := JsonToEquipmentNodeSelection(JObj(AObj, 'downstreamNode'));
  Result.downstreamPortLabel := JStr(AObj, 'downstreamPortLabel');
  Result.id := JInt64(AObj, 'id');
  Result.linkDescription := JStr(AObj, 'linkDescription');
  Result.relation := JStr(AObj, 'relation');
  Result.upstreamNode := JsonToEquipmentNodeSelection(JObj(AObj, 'upstreamNode'));
  Result.upstreamPortLabel := JStr(AObj, 'upstreamPortLabel');
END;

FUNCTION JsonToConnections(AArr: TJSONArray): tyConnections;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToConnection(JItemObj(AArr, I));
END;

FUNCTION JsonToSapSystem(AObj: TJSONObject): tySapSystem;
BEGIN
  Result := Default(tySapSystem);
  IF AObj = NIL THEN
    Exit;
  Result.abapCentralService := JsonToReferenceWithNameAndType(JObj(AObj, 'abapCentralService'));
  Result.authClientId := JStr(AObj, 'authClientId');
  Result.authClientSecret := JStr(AObj, 'authClientSecret');
  Result.authPassword := JStr(AObj, 'authPassword');
  Result.authPort := JInt(AObj, 'authPort');
  Result.authUser := JStr(AObj, 'authUser');
  Result.authenticationMode := JStr(AObj, 'authenticationMode');
  Result.clientId := JStr(AObj, 'clientId');
  Result.dbConnectionName := JStr(AObj, 'dbConnectionName');
  Result.description := JStr(AObj, 'description');
  Result.engine := JsonToReferenceWithDescription(JObj(AObj, 'engine'));
  Result.environment := JsonToReferenceWithName(JObj(AObj, 'environment'));
  Result.equipment := JsonToReferenceWithNameAndType(JObj(AObj, 'equipment'));
  Result.externalReference := JStr(AObj, 'externalReference');
  Result.fingerprint := JStr(AObj, 'fingerprint');
  Result.id := JInt64(AObj, 'id');
  Result.infrastructureMode := JStr(AObj, 'infrastructureMode');
  Result.instances := JsonToSapInstances(JArr(AObj, 'instances'));
  Result.inventoryEnabled := JBool(AObj, 'inventoryEnabled');
  Result.javaCentralService := JsonToReferenceWithNameAndType(JObj(AObj, 'javaCentralService'));
  Result.javaPassword := JStr(AObj, 'javaPassword');
  Result.javaUsername := JStr(AObj, 'javaUsername');
  Result.lastInventoryMessage := JStr(AObj, 'lastInventoryMessage');
  Result.lastInventoryTimestamp := JDate(AObj, 'lastInventoryTimestamp');
  Result.lastInventoryUser := JStr(AObj, 'lastInventoryUser');
  Result.logonGroup := JStr(AObj, 'logonGroup');
  Result.logonGroupEnabled := JBool(AObj, 'logonGroupEnabled');
  Result.logonGroupPort := JInt(AObj, 'logonGroupPort');
  Result.monitoringEnabled := JBool(AObj, 'monitoringEnabled');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.password := JStr(AObj, 'password');
  Result.region := JStr(AObj, 'region');
  Result.remarks := JStr(AObj, 'remarks');
  Result.router := JStr(AObj, 'router');
  Result.serverName := JStr(AObj, 'serverName');
  Result.sncEnabled := JBool(AObj, 'sncEnabled');
  Result.sncMyName := JStr(AObj, 'sncMyName');
  Result.sncPartnerName := JStr(AObj, 'sncPartnerName');
  Result.sncSecurityLevel := JStr(AObj, 'sncSecurityLevel');
  Result.stackType := JStr(AObj, 'stackType');
  Result.systemId := JStr(AObj, 'systemId');
  Result.tags := JsonToReferenceWithNames(JArr(AObj, 'tags'));
  Result.tenant := JStr(AObj, 'tenant');
  Result.typeSpecificFields := JsonToNodeTypeSpecificFieldLinks(JArr(AObj, 'typeSpecificFields'));
  Result.url := JStr(AObj, 'url');
  Result.username := JStr(AObj, 'username');
  Result.uuid := JStr(AObj, 'uuid');
END;

FUNCTION JsonToSapSystems(AArr: TJSONArray): tySapSystems;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToSapSystem(JItemObj(AArr, I));
END;

FUNCTION JsonToMaintenanceWindowExceptional(AObj: TJSONObject): tyMaintenanceWindowExceptional;
BEGIN
  Result := Default(tyMaintenanceWindowExceptional);
  IF AObj = NIL THEN
    Exit;
  Result.checkIds := JArrToInt64s(JArr(AObj, 'checkIds'));
  Result.creationTimestamp := JDate(AObj, 'creationTimestamp');
  Result.creationUser := JStr(AObj, 'creationUser');
  Result.description := JStr(AObj, 'description');
  Result.disengagementMode := JStr(AObj, 'disengagementMode');
  Result.endDate := JDate(AObj, 'endDate');
  Result.hciIds := JArrToInt64s(JArr(AObj, 'hciIds'));
  Result.id := JInt64(AObj, 'id');
  Result.lastUpdateTimestamp := JDate(AObj, 'lastUpdateTimestamp');
  Result.lastUpdateUser := JStr(AObj, 'lastUpdateUser');
  Result.networkIds := JArrToInt64s(JArr(AObj, 'networkIds'));
  Result.notes := JStr(AObj, 'notes');
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.serverIds := JArrToInt64s(JArr(AObj, 'serverIds'));
  Result.serviceStatusImpact := JStr(AObj, 'serviceStatusImpact');
  Result.services := JsonToReferenceWithNames(JArr(AObj, 'services'));
  Result.specificNodeIds := JArrToInt64s(JArr(AObj, 'specificNodeIds'));
  Result.startDate := JDate(AObj, 'startDate');
  Result.storageIds := JArrToInt64s(JArr(AObj, 'storageIds'));
  Result.ticketIds := JArrToInt64s(JArr(AObj, 'ticketIds'));
  Result.timeZone := JStr(AObj, 'timeZone');
END;

FUNCTION JsonToMaintenanceWindowExceptionals(AArr: TJSONArray): tyMaintenanceWindowExceptionals;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToMaintenanceWindowExceptional(JItemObj(AArr, I));
END;

FUNCTION MaintenanceWindowExceptionalToJson(CONST ARec: tyMaintenanceWindowExceptional): TJSONObject;
BEGIN
  Result := JNewObj;
  IF Length(ARec.checkIds) > 0 THEN
    JAddValue(Result, 'checkIds', Int64sToJArr(ARec.checkIds));
  JAddStr(Result, 'description', ARec.description);
  JAddStr(Result, 'disengagementMode', ARec.disengagementMode);
  JAddDate(Result, 'endDate', ARec.endDate);
  IF Length(ARec.hciIds) > 0 THEN
    JAddValue(Result, 'hciIds', Int64sToJArr(ARec.hciIds));
  IF Length(ARec.networkIds) > 0 THEN
    JAddValue(Result, 'networkIds', Int64sToJArr(ARec.networkIds));
  IF ARec.notes <> '' THEN
    JAddStr(Result, 'notes', ARec.notes);
  JAddValue(Result, 'organization', ReferenceWithNameToJson(ARec.organization));
  IF Length(ARec.serverIds) > 0 THEN
    JAddValue(Result, 'serverIds', Int64sToJArr(ARec.serverIds));
  IF ARec.serviceStatusImpact <> '' THEN
    JAddStr(Result, 'serviceStatusImpact', ARec.serviceStatusImpact);
  IF Length(ARec.services) > 0 THEN
    JAddValue(Result, 'services', ReferenceWithNamesToJson(ARec.services));
  IF Length(ARec.specificNodeIds) > 0 THEN
    JAddValue(Result, 'specificNodeIds', Int64sToJArr(ARec.specificNodeIds));
  JAddDate(Result, 'startDate', ARec.startDate);
  IF Length(ARec.storageIds) > 0 THEN
    JAddValue(Result, 'storageIds', Int64sToJArr(ARec.storageIds));
  IF Length(ARec.ticketIds) > 0 THEN
    JAddValue(Result, 'ticketIds', Int64sToJArr(ARec.ticketIds));
  IF ARec.timeZone <> '' THEN
    JAddStr(Result, 'timeZone', ARec.timeZone);
END;

FUNCTION MaintenanceWindowExceptionalsToJson(CONST AArr: tyMaintenanceWindowExceptionals): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, MaintenanceWindowExceptionalToJson(AArr[I]));
END;

FUNCTION JsonToPassword(AObj: TJSONObject): tyPassword;
BEGIN
  Result := Default(tyPassword);
  IF AObj = NIL THEN
    Exit;
  Result.apps := JsonToReferenceWithDescriptions(JArr(AObj, 'apps'));
  Result.data := JRaw(AObj, 'data');
  Result.databases := JsonToReferenceWithDescriptions(JArr(AObj, 'databases'));
  Result.description := JStr(AObj, 'description');
  Result.expirationDate := JDate(AObj, 'expirationDate');
  Result.expirationNotificationDelay := JInt(AObj, 'expirationNotificationDelay');
  Result.folder := JsonToReferenceWithName(JObj(AObj, 'folder'));
  Result.hciPlatforms := JsonToReferenceWithNames(JArr(AObj, 'hciPlatforms'));
  Result.id := JInt64(AObj, 'id');
  Result.networks := JsonToReferenceWithNames(JArr(AObj, 'networks'));
  Result.officeEquipments := JsonToReferenceWithDescriptions(JArr(AObj, 'officeEquipments'));
  Result.organization := JsonToReferenceWithName(JObj(AObj, 'organization'));
  Result.passphrase := JStr(AObj, 'passphrase');
  Result.passphraseProtected := JBool(AObj, 'passphraseProtected');
  Result.password := JStr(AObj, 'password');
  Result.sapSystems := JsonToReferenceWithDescriptions(JArr(AObj, 'sapSystems'));
  Result.servers := JsonToReferenceWithNames(JArr(AObj, 'servers'));
  Result.specificNodes := JsonToReferenceWithNames(JArr(AObj, 'specificNodes'));
  Result.storage := JsonToReferenceWithNames(JArr(AObj, 'storage'));
  Result.type_ := JsonToReferenceWithReference(JObj(AObj, 'type'));
  Result.url := JStr(AObj, 'url');
  Result.username := JStr(AObj, 'username');
  Result.vault := JsonToReferenceWithName(JObj(AObj, 'vault'));
END;

FUNCTION JsonToPasswords(AArr: TJSONArray): tyPasswords;
VAR
  I: Integer;
BEGIN
  Result := NIL;
  SetLength(Result, JCount(AArr));
  FOR I := 0 TO High(Result) DO
    Result[I] := JsonToPassword(JItemObj(AArr, I));
END;

FUNCTION SortToJson(CONST ARec: tySort): TJSONObject;
BEGIN
  Result := JNewObj;
  JAddStr(Result, 'column', ARec.column);
  IF ARec.dir <> '' THEN
    JAddStr(Result, 'dir', ARec.dir);
END;

FUNCTION SortsToJson(CONST AArr: tySorts): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, SortToJson(AArr[I]));
END;

FUNCTION PageRequestToJson(CONST ARec: tyPageRequest): TJSONObject;
BEGIN
  Result := JNewObj;
  JAddInt(Result, 'page', ARec.page);
  JAddInt(Result, 'pageSize', ARec.pageSize);
  IF Length(ARec.sort) > 0 THEN
    JAddValue(Result, 'sort', SortsToJson(ARec.sort));
END;

FUNCTION PageRequestsToJson(CONST AArr: tyPageRequests): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, PageRequestToJson(AArr[I]));
END;

FUNCTION PageRequestWithSearchToJson(CONST ARec: tyPageRequestWithSearch): TJSONObject;
BEGIN
  Result := JNewObj;
  JAddValue(Result, 'pageRequest', PageRequestToJson(ARec.pageRequest));
  IF ARec.query <> '' THEN
    JAddStr(Result, 'query', ARec.query);
END;

FUNCTION PageRequestWithSearchsToJson(CONST AArr: tyPageRequestWithSearchs): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, PageRequestWithSearchToJson(AArr[I]));
END;

FUNCTION ListToJson(CONST ARec: tyList): TJSONObject;
BEGIN
  Result := JNewObj;
  JAddValue(Result, 'pageRequestWithSearchBean', PageRequestWithSearchToJson(ARec.pageRequestWithSearchBean));
  IF Length(ARec.tags) > 0 THEN
    JAddValue(Result, 'tags', StrsToJArr(ARec.tags));
END;

FUNCTION ListsToJson(CONST AArr: tyLists): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, ListToJson(AArr[I]));
END;

FUNCTION SecuredDataListToJson(CONST ARec: tySecuredDataList): TJSONObject;
BEGIN
  Result := JNewObj;
  IF ARec.appId <> 0 THEN
    JAddInt(Result, 'appId', ARec.appId);
  IF ARec.dbServerId <> 0 THEN
    JAddInt(Result, 'dbServerId', ARec.dbServerId);
  IF ARec.equipmentId <> 0 THEN
    JAddInt(Result, 'equipmentId', ARec.equipmentId);
  IF ARec.folderId <> 0 THEN
    JAddInt(Result, 'folderId', ARec.folderId);
  IF ARec.hciId <> 0 THEN
    JAddInt(Result, 'hciId', ARec.hciId);
  IF ARec.networkId <> 0 THEN
    JAddInt(Result, 'networkId', ARec.networkId);
  IF ARec.organizationId <> 0 THEN
    JAddInt(Result, 'organizationId', ARec.organizationId);
  JAddValue(Result, 'pageRequestBean', PageRequestToJson(ARec.pageRequestBean));
  IF ARec.sapId <> 0 THEN
    JAddInt(Result, 'sapId', ARec.sapId);
  IF ARec.search <> '' THEN
    JAddStr(Result, 'search', ARec.search);
  IF ARec.serverId <> 0 THEN
    JAddInt(Result, 'serverId', ARec.serverId);
  IF ARec.specificNodeId <> 0 THEN
    JAddInt(Result, 'specificNodeId', ARec.specificNodeId);
  IF ARec.storageId <> 0 THEN
    JAddInt(Result, 'storageId', ARec.storageId);
  IF ARec.typeId <> 0 THEN
    JAddInt(Result, 'typeId', ARec.typeId);
  IF ARec.vaultId <> 0 THEN
    JAddInt(Result, 'vaultId', ARec.vaultId);
END;

FUNCTION SecuredDataListsToJson(CONST AArr: tySecuredDataLists): TJSONArray;
VAR
  I: Integer;
BEGIN
  Result := JNewArr;
  FOR I := 0 TO High(AArr) DO
    JArrAddValue(Result, SecuredDataListToJson(AArr[I]));
END;

{ TCockpitItsmInstance }

FUNCTION TCockpitItsmInstance.GetInfrastructureEquipment(ATypeId: Int64; AId: Int64): tyEquipment;
// GET /api/infrastructure/equipment/{typeId}/{id} - Get information about an infrastructure equipment (Server, hci, storage, network or custom type)
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('GET', '/api/infrastructure/equipment/' + IntToStr(ATypeId) + '/' + IntToStr(AId));
  TRY
    Result := JsonToEquipment(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.GetInfrastructureSapSystem(ASystemId: Int64): tySapSystemWithInfo;
// GET /api/infrastructure/sap/system/{systemId} - Get information about a SAP system
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('GET', '/api/infrastructure/sap/system/' + IntToStr(ASystemId));
  TRY
    Result := JsonToSapSystemWithInfo(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.GetMonitoringCheck(AId: Int64): tyCheck;
// GET /api/monitoring/check/{id} - Fetch information about a check
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('GET', '/api/monitoring/check/' + IntToStr(AId));
  TRY
    Result := JsonToCheck(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.GetOrganizationByName(CONST AName: STRING): tyOrganization;
// GET /api/organization/by-name - Get an organization by name
VAR
  Q: STRING;
  Resp: TJSONValue;
BEGIN
  Q := '';
  AddQuery(Q, 'name', AName);
  Resp := CallJson('GET', '/api/organization/by-name' + Q);
  TRY
    Result := JsonToOrganization(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.ListOrganization: tyOrganizationSelections;
// GET /api/organization/list - Get a list of organizations the current user has access to
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('GET', '/api/organization/list');
  TRY
    Result := JsonToOrganizationSelections(JAsArr(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.GetSecuredData(AId: Int64): STRING;
// GET /api/secured-data/{id} - Get detailed information about a secured data
BEGIN
  Result := Call('GET', '/api/secured-data/' + IntToStr(AId));
END;

FUNCTION TCockpitItsmInstance.PostConfigurationParameters(CONST AItems: TCockpitIntegers): tyConfigurationParameters;
// POST /api/configuration-parameters - Get configuration parameters
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('POST', '/api/configuration-parameters', JToStringFree(IntegersToJArr(AItems)));
  TRY
    Result := JsonToConfigurationParameters(JAsArr(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureDb(AOrganizationId: Int64 = 0): tyDatabaseServers;
// POST /api/infrastructure/db/list - all pages, no criteria
BEGIN
  Result := ListInfrastructureDb(Default(tyPageRequestWithSearch), AOrganizationId);
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureDb(CONST ACriteria: tyPageRequestWithSearch; AOrganizationId: Int64 = 0): tyDatabaseServers;
// POST /api/infrastructure/db/list - List of DB servers. Available sorting properties: organization, description
VAR
  Q: STRING;
  Body: TJSONObject;
  Items: TJSONArray;
BEGIN
  Q := '';
  IF AOrganizationId <> 0 THEN
    AddQuery(Q, 'organizationId', IntToStr(AOrganizationId));
  Body := PageRequestWithSearchToJson(ACriteria);
  TRY
    Items := FetchAllPages('POST', '/api/infrastructure/db/list' + Q, Body, 'pageRequest');
  FINALLY
    Body.Free;
  END;
  TRY
    Result := JsonToDatabaseServers(Items);
  FINALLY
    Items.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureRelationships: tyConnections;
// POST /api/infrastructure/relationships/list - all pages, no criteria
BEGIN
  Result := ListInfrastructureRelationships(Default(tyPageRequestWithSearch));
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureRelationships(CONST ACriteria: tyPageRequestWithSearch): tyConnections;
// POST /api/infrastructure/relationships/list - List infrastructure relationships
VAR
  Body: TJSONObject;
  Items: TJSONArray;
BEGIN
  Body := PageRequestWithSearchToJson(ACriteria);
  TRY
    Items := FetchAllPages('POST', '/api/infrastructure/relationships/list', Body, 'pageRequest');
  FINALLY
    Body.Free;
  END;
  TRY
    Result := JsonToConnections(Items);
  FINALLY
    Items.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureSap(AOrganizationId: Int64 = 0): tySapSystems;
// POST /api/infrastructure/sap/list - all pages, no criteria
BEGIN
  Result := ListInfrastructureSap(Default(tyPageRequestWithSearch), AOrganizationId);
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureSap(CONST ACriteria: tyPageRequestWithSearch; AOrganizationId: Int64 = 0): tySapSystems;
// POST /api/infrastructure/sap/list - List of SAP systems. Available sorting properties: description, type, organization, environment
VAR
  Q: STRING;
  Body: TJSONObject;
  Items: TJSONArray;
BEGIN
  Q := '';
  IF AOrganizationId <> 0 THEN
    AddQuery(Q, 'organizationId', IntToStr(AOrganizationId));
  Body := PageRequestWithSearchToJson(ACriteria);
  TRY
    Items := FetchAllPages('POST', '/api/infrastructure/sap/list' + Q, Body, 'pageRequest');
  FINALLY
    Body.Free;
  END;
  TRY
    Result := JsonToSapSystems(Items);
  FINALLY
    Items.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureServer(AOrganizationId: Int64 = 0): tyEquipments;
// POST /api/infrastructure/server/list - all pages, no criteria
BEGIN
  Result := ListInfrastructureServer(Default(tyList), AOrganizationId);
END;

FUNCTION TCockpitItsmInstance.ListInfrastructureServer(CONST ACriteria: tyList; AOrganizationId: Int64 = 0): tyEquipments;
// POST /api/infrastructure/server/list - List servers. Available sorting properties: id, organization, name, description
VAR
  Q: STRING;
  Body: TJSONObject;
  Items: TJSONArray;
BEGIN
  Q := '';
  IF AOrganizationId <> 0 THEN
    AddQuery(Q, 'organizationId', IntToStr(AOrganizationId));
  Body := ListToJson(ACriteria);
  TRY
    Items := FetchAllPages('POST', '/api/infrastructure/server/list' + Q, Body, 'pageRequestWithSearchBean.pageRequest');
  FINALLY
    Body.Free;
  END;
  TRY
    Result := JsonToEquipments(Items);
  FINALLY
    Items.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.PostMonitoringExceptionalMaintenanceWindow(CONST AMaintenanceWindowExceptional: tyMaintenanceWindowExceptional): tyMaintenanceWindowExceptional;
// POST /api/monitoring/exceptional-maintenance-window - Create a new exceptional maintenance window
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('POST', '/api/monitoring/exceptional-maintenance-window', JToStringFree(MaintenanceWindowExceptionalToJson(AMaintenanceWindowExceptional)));
  TRY
    Result := JsonToMaintenanceWindowExceptional(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.PostSecuredDataDecrypt(AId: Int64; CONST AText: STRING): STRING;
// POST /api/secured-data/{id}/decrypt - Decrypt a secured data.
BEGIN
  Result := Call('POST', '/api/secured-data/' + IntToStr(AId) + '/decrypt', AText);
END;

FUNCTION TCockpitItsmInstance.ListSecuredData: tyPasswords;
// POST /api/secured-data/list - all pages, no criteria
BEGIN
  Result := ListSecuredData(Default(tySecuredDataList));
END;

FUNCTION TCockpitItsmInstance.ListSecuredData(CONST ACriteria: tySecuredDataList): tyPasswords;
// POST /api/secured-data/list - List of secured data. Available sorting properties: description, type, username, organization
VAR
  Body: TJSONObject;
  Items: TJSONArray;
BEGIN
  Body := SecuredDataListToJson(ACriteria);
  TRY
    Items := FetchAllPages('POST', '/api/secured-data/list', Body, 'pageRequestBean');
  FINALLY
    Body.Free;
  END;
  TRY
    Result := JsonToPasswords(Items);
  FINALLY
    Items.Free;
  END;
END;

FUNCTION TCockpitItsmInstance.PutMonitoringExceptionalMaintenanceWindow(CONST AMaintenanceWindowExceptional: tyMaintenanceWindowExceptional): tyMaintenanceWindowExceptional;
// PUT /api/monitoring/exceptional-maintenance-window - Update an existing exceptional maintenance window
VAR
  Resp: TJSONValue;
BEGIN
  Resp := CallJson('PUT', '/api/monitoring/exceptional-maintenance-window', JToStringFree(MaintenanceWindowExceptionalToJson(AMaintenanceWindowExceptional)));
  TRY
    Result := JsonToMaintenanceWindowExceptional(JAsObj(Resp));
  FINALLY
    Resp.Free;
  END;
END;

END.
