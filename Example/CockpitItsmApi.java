// Cockpit ITSM public API - GENERATED CLASS, do not edit (regenerate with CIPAT4P)
// Source: Cockpit ITSM Portal - Public API 2026.8.4 - generated 2026-11-03 10:48
// Requires CockpitItsmCore.java (same folder) and org.json (JSONObject / JSONArray)
//
// Selected endpoints (read back by CIPAT4P when regenerating):
// @endpoint GET /api/infrastructure/db/server/{dbServerId} GetInfrastructureDbServer
// @endpoint GET /api/infrastructure/equipment/{typeId}/{id} GetInfrastructureEquipment
// @endpoint GET /api/infrastructure/sap/system/{systemId} GetInfrastructureSapSystem
// @endpoint GET /api/monitoring/check/{id} GetMonitoringCheck
// @endpoint GET /api/organization/by-name GetOrganizationByName
// @endpoint POST /api/infrastructure/relationships/list ListInfrastructureRelationships
// @endpoint POST /api/monitoring/exceptional-maintenance-window PostMonitoringExceptionalMaintenanceWindow
// @endpoint POST /api/secured-data/{id} PostSecuredDataById
// @endpoint POST /api/secured-data/{id}/decrypt PostSecuredDataDecrypt
// @endpoint PUT /api/monitoring/exceptional-maintenance-window PutMonitoringExceptionalMaintenanceWindow

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Typed access to the selected endpoints of the Cockpit ITSM public API.
 * <pre>
 * CockpitItsmApi api = new CockpitItsmApi(true, "tenant", "clientId", "clientSecret");
 * </pre>
 * Members and optional parameters: null = missing / not sent. Paged lists: all pages.
 * Errors: CockpitItsmCore.CockpitItsmException (HTTP status and response).
 */
public class CockpitItsmApi extends CockpitItsmCore {

    public CockpitItsmApi() {
    }

    public CockpitItsmApi(boolean saas, String tenant, String clientId, String clientSecret) {
        super(saas, tenant, clientId, clientSecret);
    }

    // ---------------------------------------------------------------- types

    /** An object reference (id and description) */
    public static class ReferenceWithDescription {
        /** [read-only] Description of the reference target */
        public String description;
        /** ID of the reference target */
        public Long id;

        public static ReferenceWithDescription fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            ReferenceWithDescription res = new ReferenceWithDescription();
            res.description = toStr(src.opt("description"));
            res.id = toLong(src.opt("id"));
            return res;
        }

        public static java.util.List<ReferenceWithDescription> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** database data */
    public static class Database {
        /** DB ID */
        public Long id;
        /** Metric enabled ? */
        public Boolean metricsEnabled;
        /** DB name */
        public String name;
        /** [read-only] DB server (equipment) */
        public ReferenceWithDescription server;

        public static Database fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Database res = new Database();
            res.id = toLong(src.opt("id"));
            res.metricsEnabled = toBool(src.opt("metricsEnabled"));
            res.name = toStr(src.opt("name"));
            res.server = ReferenceWithDescription.fromJson(asObj(src.opt("server")));
            return res;
        }

        public static java.util.List<Database> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** An object reference (id, name and type) */
    public static class ReferenceWithNameAndType {
        /** ID of the reference target */
        public Long id;
        /** [read-only] Name of the reference target */
        public String name;
        /** Type of the reference target */
        public String type;

        public static ReferenceWithNameAndType fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            ReferenceWithNameAndType res = new ReferenceWithNameAndType();
            res.id = toLong(src.opt("id"));
            res.name = toStr(src.opt("name"));
            res.type = toStr(src.opt("type"));
            return res;
        }

        public static java.util.List<ReferenceWithNameAndType> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** An object reference (id and name) */
    public static class ReferenceWithName {
        /** ID of the reference target */
        public Long id;
        /** [read-only] Name of the reference target */
        public String name;

        public static ReferenceWithName fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            ReferenceWithName res = new ReferenceWithName();
            res.id = toLong(src.opt("id"));
            res.name = toStr(src.opt("name"));
            return res;
        }

        public static java.util.List<ReferenceWithName> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "id", this.id);
            return res;
        }

        public static JSONArray listToJson(java.util.List<ReferenceWithName> items) {
            return array(items, ReferenceWithName::toJson);
        }
    }

    public static class NodeTypeSpecificFieldOption {
        /** [read-only] ID */
        public Long id;
        /** The name of the item menu */
        public String value;

        public static NodeTypeSpecificFieldOption fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            NodeTypeSpecificFieldOption res = new NodeTypeSpecificFieldOption();
            res.id = toLong(src.opt("id"));
            res.value = toStr(src.opt("value"));
            return res;
        }

        public static java.util.List<NodeTypeSpecificFieldOption> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Node type specific field */
    public static class NodeTypeSpecificField {
        /** The element column */
        public Integer column;
        /** The default value of decimal field */
        public Double defaultDecimalValue;
        /** The default value of integer field OR '2' for option 'Checked by default' (depends on specific fi... */
        public Integer defaultIntegerValue;
        /** The default value of 1-line-text field */
        public String defaultTextValue;
        /** The element fraction. (number of column occupied, range 1-12) */
        public Integer fraction;
        /** [read-only] Unique ID */
        public Long id;
        /** This flag controls whether the specific field represents a mandatory field, i.e. a value must be ... */
        public Boolean mandatory;
        /** The name of the specific field */
        public String name;
        /** The combobox items */
        public java.util.List<NodeTypeSpecificFieldOption> options;
        /** The element row */
        public Integer row;
        /** The type of the specific field */
        public String type;

        public static NodeTypeSpecificField fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            NodeTypeSpecificField res = new NodeTypeSpecificField();
            res.column = toInt(src.opt("column"));
            res.defaultDecimalValue = toDouble(src.opt("defaultDecimalValue"));
            res.defaultIntegerValue = toInt(src.opt("defaultIntegerValue"));
            res.defaultTextValue = toStr(src.opt("defaultTextValue"));
            res.fraction = toInt(src.opt("fraction"));
            res.id = toLong(src.opt("id"));
            res.mandatory = toBool(src.opt("mandatory"));
            res.name = toStr(src.opt("name"));
            res.options = NodeTypeSpecificFieldOption.listFromJson(asArr(src.opt("options")));
            res.row = toInt(src.opt("row"));
            res.type = toStr(src.opt("type"));
            return res;
        }

        public static java.util.List<NodeTypeSpecificField> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    public static class NodeTypeSpecificFieldLink {
        /** The specific field date value, if any */
        public java.time.LocalDate dateValue;
        /** The specific field decimal value, if any */
        public Double decimalValue;
        /** [read-only] Unique ID */
        public Long id;
        /** The specific field integer value, if any */
        public Integer intValue;
        /** The specific field option, if any */
        public NodeTypeSpecificFieldOption option;
        /** The specific field */
        public NodeTypeSpecificField specificField;
        /** The specific field text value, if any */
        public String textValue;

        public static NodeTypeSpecificFieldLink fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            NodeTypeSpecificFieldLink res = new NodeTypeSpecificFieldLink();
            res.dateValue = toDate(src.opt("dateValue"));
            res.decimalValue = toDouble(src.opt("decimalValue"));
            res.id = toLong(src.opt("id"));
            res.intValue = toInt(src.opt("intValue"));
            res.option = NodeTypeSpecificFieldOption.fromJson(asObj(src.opt("option")));
            res.specificField = NodeTypeSpecificField.fromJson(asObj(src.opt("specificField")));
            res.textValue = toStr(src.opt("textValue"));
            return res;
        }

        public static java.util.List<NodeTypeSpecificFieldLink> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** DB server data */
    public static class DatabaseServer {
        /** Connection option */
        public String connectionOption;
        /** Connection type */
        public String connectionType;
        /** Databases on this server (skipped in lists). If not specified on UPDATE, the databases are left u... */
        public java.util.List<Database> databases;
        /** DB driver */
        public String dbDriver;
        /** Unique per organization */
        public String description;
        /** Equipment */
        public ReferenceWithNameAndType equipment;
        /** Database external reference */
        public String externalReference;
        /** DB server ID */
        public Long id;
        /** JDBC URL */
        public String jdbcUrl;
        /** Metrics enabled ? */
        public Boolean metricsEnabled;
        /** Monitoring enabled ? */
        public Boolean monitoringEnabled;
        /** Organization */
        public ReferenceWithName organization;
        /** Password */
        public String password;
        /** Port */
        public Integer port;
        /** Remarks */
        public String remarks;
        /** The node type specific fields */
        public java.util.List<NodeTypeSpecificFieldLink> typeSpecificFields;
        /** Username */
        public String username;
        /** Database UUID */
        public String uuid;

        public static DatabaseServer fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            DatabaseServer res = new DatabaseServer();
            res.connectionOption = toStr(src.opt("connectionOption"));
            res.connectionType = toStr(src.opt("connectionType"));
            res.databases = Database.listFromJson(asArr(src.opt("databases")));
            res.dbDriver = toStr(src.opt("dbDriver"));
            res.description = toStr(src.opt("description"));
            res.equipment = ReferenceWithNameAndType.fromJson(asObj(src.opt("equipment")));
            res.externalReference = toStr(src.opt("externalReference"));
            res.id = toLong(src.opt("id"));
            res.jdbcUrl = toStr(src.opt("jdbcUrl"));
            res.metricsEnabled = toBool(src.opt("metricsEnabled"));
            res.monitoringEnabled = toBool(src.opt("monitoringEnabled"));
            res.organization = ReferenceWithName.fromJson(asObj(src.opt("organization")));
            res.password = toStr(src.opt("password"));
            res.port = toInt(src.opt("port"));
            res.remarks = toStr(src.opt("remarks"));
            res.typeSpecificFields = NodeTypeSpecificFieldLink.listFromJson(asArr(src.opt("typeSpecificFields")));
            res.username = toStr(src.opt("username"));
            res.uuid = toStr(src.opt("uuid"));
            return res;
        }

        public static java.util.List<DatabaseServer> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    public static class Translation {
        /** Translation for contacts */
        public String contact;
        /** The translation ID */
        public Long id;
        /** Language */
        public String language;
        /** Translation for operators */
        public String operator;

        public static Translation fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Translation res = new Translation();
            res.contact = toStr(src.opt("contact"));
            res.id = toLong(src.opt("id"));
            res.language = toStr(src.opt("language"));
            res.operator = toStr(src.opt("operator"));
            return res;
        }

        public static java.util.List<Translation> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    public static class SpecificProperty {
        /** [read-only] Unique ID */
        public Long id;
        /** [read-only] Timestamp of last update to this object */
        public java.time.Instant lastUpdateTimestamp;
        /** [read-only] Author of last update to this object */
        public String lastUpdateUser;
        /** Is this mandatory? */
        public Boolean mandatory;
        /** [read-only] Number of items associated with this object. Read-only property only filled in in lists. */
        public Integer numberOfItems;
        /** The associated options. */
        public java.util.List<ReferenceWithDescription> options;
        /** The reference */
        public String reference;
        /** The translations */
        public java.util.List<Translation> translations;

        public static SpecificProperty fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            SpecificProperty res = new SpecificProperty();
            res.id = toLong(src.opt("id"));
            res.lastUpdateTimestamp = toDateTime(src.opt("lastUpdateTimestamp"));
            res.lastUpdateUser = toStr(src.opt("lastUpdateUser"));
            res.mandatory = toBool(src.opt("mandatory"));
            res.numberOfItems = toInt(src.opt("numberOfItems"));
            res.options = ReferenceWithDescription.listFromJson(asArr(src.opt("options")));
            res.reference = toStr(src.opt("reference"));
            res.translations = Translation.listFromJson(asArr(src.opt("translations")));
            return res;
        }

        public static java.util.List<SpecificProperty> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Specific property on equipment */
    public static class SpecificPropertyOnEquipment {
        /** [read-only] Unique ID */
        public Long id;
        /** The custom equipment property option */
        public ReferenceWithDescription option;
        /** The custom equipment property */
        public SpecificProperty property;
        /** The custom equipment property name (translated) */
        public String propertyName;

        public static SpecificPropertyOnEquipment fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            SpecificPropertyOnEquipment res = new SpecificPropertyOnEquipment();
            res.id = toLong(src.opt("id"));
            res.option = ReferenceWithDescription.fromJson(asObj(src.opt("option")));
            res.property = SpecificProperty.fromJson(asObj(src.opt("property")));
            res.propertyName = toStr(src.opt("propertyName"));
            return res;
        }

        public static java.util.List<SpecificPropertyOnEquipment> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** An object reference (id and reference) */
    public static class ReferenceWithReference {
        /** ID of the reference target */
        public Long id;
        /** [read-only] Reference of the reference target */
        public String reference;

        public static ReferenceWithReference fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            ReferenceWithReference res = new ReferenceWithReference();
            res.id = toLong(src.opt("id"));
            res.reference = toStr(src.opt("reference"));
            return res;
        }

        public static java.util.List<ReferenceWithReference> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "id", this.id);
            return res;
        }

        public static JSONArray listToJson(java.util.List<ReferenceWithReference> items) {
            return array(items, ReferenceWithReference::toJson);
        }
    }

    /** Equipment data */
    public static class Equipment {
        /** Equipment accounting notes */
        public String accountingNotes;
        /** [read-only] Equipment amortization done */
        public Double amortizationDoneAmount;
        /** Equipment amortization duration in years */
        public Integer amortizationDuration;
        /** [read-only] Equipment amortization end (without time and TZ) */
        public java.time.LocalDate amortizationEnd;
        /** [read-only] Equipment last amortization (without time and TZ) */
        public java.time.LocalDate amortizationLast;
        /** Equipment amortization start (without time and TZ) */
        public java.time.LocalDate amortizationStart;
        /** [read-only] Equipment amortization to go */
        public Double amortizationToGoAmount;
        /** Equipment asset reference */
        public String assetReference;
        /** Equipment brand */
        public String brand;
        /** Equipment connection timeout (in seconds). If not specified, the default timeout is used */
        public Long connectionTimeout;
        /** Equipment connection type */
        public String connectionType;
        /** Equipment data center */
        public ReferenceWithName dataCenter;
        /** Equipment description */
        public String description;
        /** Equipment DNS name */
        public String dnsName;
        /** Equipment engine ID */
        public Long engineId;
        /** Equipment environment */
        public ReferenceWithName environment;
        /** Equipment external reference */
        public String externalReference;
        /** Equipment ESX HostSystem */
        public String hostSystem;
        /** Equipment ID */
        public Long id;
        /** Automated inventory enabled if supported for this system. Default value: false */
        public Boolean inventoryEnabled;
        /** Equipment invoice amount */
        public Double invoiceAmount;
        /** Equipment invoice date (without time and TZ) */
        public java.time.LocalDate invoiceDate;
        /** Equipment invoice reference */
        public String invoiceReference;
        /** [read-only] Message produced by latest inventory */
        public String lastInventoryMessage;
        /** [read-only] Timestamp of latest inventory */
        public java.time.Instant lastInventoryTimestamp;
        /** [read-only] User who launched the latest inventory */
        public String lastInventoryUser;
        /** Equipment location */
        public ReferenceWithDescription location;
        /** Node location option */
        public String locationOption;
        /** Equipment location site */
        public ReferenceWithDescription locationSite;
        /** Metrics enabled? Default value: false */
        public Boolean metricsEnabled;
        /** Equipment model */
        public String model;
        /** Monitoring enabled? Default value: true */
        public Boolean monitoringEnabled;
        /** Unique per organization */
        public String name;
        /** Equipment notes */
        public String notes;
        public Double numberOfOrganizations;
        /** Equipment order reference */
        public String orderReference;
        /** Equipment organization */
        public ReferenceWithName organization;
        /** Equipment organizations filter */
        public String organizationFilter;
        /** Organizations the equipment is shared with (ignored if structureFilter is NONE) */
        public java.util.List<ReferenceWithName> organizations;
        /** Equipment OS name (server only) */
        public String os;
        /** Username used to connect to the equipment (write-only property) */
        public String password;
        /** Equipment port */
        public Integer port;
        /** Equipment rack */
        public ReferenceWithDescription rack;
        /** Relax SSL certificate checks (ESX connections). Default value: false */
        public Boolean relaxSsl;
        /** Equipment serial number */
        public String serialNumber;
        /** Equipment SNMP authentication passphrase (SNMP connections, write-only property) */
        public String snmpAuthPassphrase;
        /** Equipment SNMP authentication protocol (SNMP connections) */
        public String snmpAuthProtocol;
        /** Equipment SNMP authentication username (SNMP connections) */
        public String snmpAuthUsername;
        /** Equipment SNMP community (SNMP connections) */
        public String snmpCommunity;
        /** Equipment SNMP port (SNMP connections) */
        public Integer snmpPort;
        /** Equipment SNMP privacy passphrase (SNMP connections, write-only property) */
        public String snmpPrivacyPassphrase;
        /** Equipment SNMP privacy protocol (SNMP connections) */
        public String snmpPrivacyProtocol;
        /** Equipment SNMP version (SNMP connections) */
        public Integer snmpVersion;
        /** Equipment common and accounting specific properties */
        public java.util.List<SpecificPropertyOnEquipment> specificProperties;
        /** Description of the SSH key used to connect (UNIX connections). Non-API object type: SSH_KEY */
        public ReferenceWithDescription sshKey;
        /** Equipment status reference */
        public ReferenceWithReference status;
        /** Equipment sub-type, possible values: Server:[PHYSICAL, VIRTUAL], Storage:[DISK_ARRAY, ARRAY_COMPO... */
        public String subType;
        /** Equipment supplier */
        public ReferenceWithName supplier;
        /** A list of tags associated to this equipment node */
        public java.util.List<ReferenceWithName> tags;
        /** Equipment technical notes */
        public String technicalNotes;
        /** Equipment type reference (Server, Hci, Network, Storage or custom types) */
        public ReferenceWithReference type;
        /** The node type specific fields */
        public java.util.List<NodeTypeSpecificFieldLink> typeSpecificFields;
        /** Use the hostSystem field instead of dnsName to connect to an ESX system. Default value: false */
        public Boolean useHostSystem;
        /** Use SSL (WinRM connections). Default value: true */
        public Boolean useSsl;
        /** Username used to connect to the equipment */
        public String username;
        /** Equipment UUID */
        public String uuid;

        public static Equipment fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Equipment res = new Equipment();
            res.accountingNotes = toStr(src.opt("accountingNotes"));
            res.amortizationDoneAmount = toDouble(src.opt("amortizationDoneAmount"));
            res.amortizationDuration = toInt(src.opt("amortizationDuration"));
            res.amortizationEnd = toDate(src.opt("amortizationEnd"));
            res.amortizationLast = toDate(src.opt("amortizationLast"));
            res.amortizationStart = toDate(src.opt("amortizationStart"));
            res.amortizationToGoAmount = toDouble(src.opt("amortizationToGoAmount"));
            res.assetReference = toStr(src.opt("assetReference"));
            res.brand = toStr(src.opt("brand"));
            res.connectionTimeout = toLong(src.opt("connectionTimeout"));
            res.connectionType = toStr(src.opt("connectionType"));
            res.dataCenter = ReferenceWithName.fromJson(asObj(src.opt("dataCenter")));
            res.description = toStr(src.opt("description"));
            res.dnsName = toStr(src.opt("dnsName"));
            res.engineId = toLong(src.opt("engineId"));
            res.environment = ReferenceWithName.fromJson(asObj(src.opt("environment")));
            res.externalReference = toStr(src.opt("externalReference"));
            res.hostSystem = toStr(src.opt("hostSystem"));
            res.id = toLong(src.opt("id"));
            res.inventoryEnabled = toBool(src.opt("inventoryEnabled"));
            res.invoiceAmount = toDouble(src.opt("invoiceAmount"));
            res.invoiceDate = toDate(src.opt("invoiceDate"));
            res.invoiceReference = toStr(src.opt("invoiceReference"));
            res.lastInventoryMessage = toStr(src.opt("lastInventoryMessage"));
            res.lastInventoryTimestamp = toDateTime(src.opt("lastInventoryTimestamp"));
            res.lastInventoryUser = toStr(src.opt("lastInventoryUser"));
            res.location = ReferenceWithDescription.fromJson(asObj(src.opt("location")));
            res.locationOption = toStr(src.opt("locationOption"));
            res.locationSite = ReferenceWithDescription.fromJson(asObj(src.opt("locationSite")));
            res.metricsEnabled = toBool(src.opt("metricsEnabled"));
            res.model = toStr(src.opt("model"));
            res.monitoringEnabled = toBool(src.opt("monitoringEnabled"));
            res.name = toStr(src.opt("name"));
            res.notes = toStr(src.opt("notes"));
            res.numberOfOrganizations = toDouble(src.opt("numberOfOrganizations"));
            res.orderReference = toStr(src.opt("orderReference"));
            res.organization = ReferenceWithName.fromJson(asObj(src.opt("organization")));
            res.organizationFilter = toStr(src.opt("organizationFilter"));
            res.organizations = ReferenceWithName.listFromJson(asArr(src.opt("organizations")));
            res.os = toStr(src.opt("os"));
            res.password = toStr(src.opt("password"));
            res.port = toInt(src.opt("port"));
            res.rack = ReferenceWithDescription.fromJson(asObj(src.opt("rack")));
            res.relaxSsl = toBool(src.opt("relaxSsl"));
            res.serialNumber = toStr(src.opt("serialNumber"));
            res.snmpAuthPassphrase = toStr(src.opt("snmpAuthPassphrase"));
            res.snmpAuthProtocol = toStr(src.opt("snmpAuthProtocol"));
            res.snmpAuthUsername = toStr(src.opt("snmpAuthUsername"));
            res.snmpCommunity = toStr(src.opt("snmpCommunity"));
            res.snmpPort = toInt(src.opt("snmpPort"));
            res.snmpPrivacyPassphrase = toStr(src.opt("snmpPrivacyPassphrase"));
            res.snmpPrivacyProtocol = toStr(src.opt("snmpPrivacyProtocol"));
            res.snmpVersion = toInt(src.opt("snmpVersion"));
            res.specificProperties = SpecificPropertyOnEquipment.listFromJson(asArr(src.opt("specificProperties")));
            res.sshKey = ReferenceWithDescription.fromJson(asObj(src.opt("sshKey")));
            res.status = ReferenceWithReference.fromJson(asObj(src.opt("status")));
            res.subType = toStr(src.opt("subType"));
            res.supplier = ReferenceWithName.fromJson(asObj(src.opt("supplier")));
            res.tags = ReferenceWithName.listFromJson(asArr(src.opt("tags")));
            res.technicalNotes = toStr(src.opt("technicalNotes"));
            res.type = ReferenceWithReference.fromJson(asObj(src.opt("type")));
            res.typeSpecificFields = NodeTypeSpecificFieldLink.listFromJson(asArr(src.opt("typeSpecificFields")));
            res.useHostSystem = toBool(src.opt("useHostSystem"));
            res.useSsl = toBool(src.opt("useSsl"));
            res.username = toStr(src.opt("username"));
            res.uuid = toStr(src.opt("uuid"));
            return res;
        }

        public static java.util.List<Equipment> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** SAP system component */
    public static class SapComponentData {
        /** [read-only] SAP component description */
        public String description;
        /** [read-only] SAP component ID */
        public Long id;
        /** [read-only] SAP component level */
        public String level;
        /** [read-only] SAP component name */
        public String name;
        /** [read-only] SAP component support package */
        public String supportPackage;
        /** [read-only] SAP component version */
        public String version;

        public static SapComponentData fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            SapComponentData res = new SapComponentData();
            res.description = toStr(src.opt("description"));
            res.id = toLong(src.opt("id"));
            res.level = toStr(src.opt("level"));
            res.name = toStr(src.opt("name"));
            res.supportPackage = toStr(src.opt("supportPackage"));
            res.version = toStr(src.opt("version"));
            return res;
        }

        public static java.util.List<SapComponentData> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** SAP instance data */
    public static class SapInstance {
        /** [read-only] Formatted description */
        public String description;
        /** Equipment hosting this instance */
        public ReferenceWithNameAndType equipment;
        /** Equipment name (cloud instance) */
        public String equipmentName;
        /** SAP instance ID */
        public Long id;
        /** Java check port (Java instances only) */
        public Integer javaCheckPort;
        /** Java port (Java instances only) */
        public Integer javaPort;
        /** [read-only] SAP system */
        public ReferenceWithDescription system;
        /** SAP system number */
        public String systemNumber;
        /** Instance type */
        public String type;
        /** Use this instance for automated inventory. Default value: false */
        public Boolean useForInventory;
        /** Use this instance for automated report generation. Default value: false */
        public Boolean useForReports;

        public static SapInstance fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            SapInstance res = new SapInstance();
            res.description = toStr(src.opt("description"));
            res.equipment = ReferenceWithNameAndType.fromJson(asObj(src.opt("equipment")));
            res.equipmentName = toStr(src.opt("equipmentName"));
            res.id = toLong(src.opt("id"));
            res.javaCheckPort = toInt(src.opt("javaCheckPort"));
            res.javaPort = toInt(src.opt("javaPort"));
            res.system = ReferenceWithDescription.fromJson(asObj(src.opt("system")));
            res.systemNumber = toStr(src.opt("systemNumber"));
            res.type = toStr(src.opt("type"));
            res.useForInventory = toBool(src.opt("useForInventory"));
            res.useForReports = toBool(src.opt("useForReports"));
            return res;
        }

        public static java.util.List<SapInstance> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** SAP system with info */
    public static class SapSystemWithInfo {
        /** Equipment hosting ABAP central service */
        public ReferenceWithNameAndType abapCentralService;
        /** [read-only] ABAP load version */
        public String abapLoadVersion;
        /** Authentication id */
        public String authClientId;
        /** Authentication secret */
        public String authClientSecret;
        /** Authentication password */
        public String authPassword;
        /** Authentication port */
        public Integer authPort;
        /** Authentication user */
        public String authUser;
        /** Authentication mode */
        public String authenticationMode;
        /** SAP client ID */
        public String clientId;
        /** [read-only] List of SAP components */
        public java.util.List<SapComponentData> components;
        /** [read-only] Components version */
        public String componentsVersion;
        /** [read-only] CUA load version */
        public String cuaLoadVersion;
        /** DB connection name (DBCO). */
        public String dbConnectionName;
        /** [read-only] DB host */
        public String dbHost;
        /** [read-only] DB library */
        public String dbLibrary;
        /** [read-only] DB name */
        public String dbName;
        /** [read-only] DB owner */
        public String dbOwner;
        /** [read-only] DB release */
        public String dbRelease;
        /** [read-only] DB size (Go) */
        public String dbSize;
        /** [read-only] DB type */
        public String dbType;
        /** Unique per organization */
        public String description;
        /** [read-only] Dialog users count */
        public String dialogUsersCount;
        /** Engine (cloud) */
        public ReferenceWithDescription engine;
        /** Environment */
        public ReferenceWithName environment;
        /** Equipment hosting SCC (on premise) */
        public ReferenceWithNameAndType equipment;
        /** SAP System external reference */
        public String externalReference;
        /** SSL certificate fingerprint */
        public String fingerprint;
        /** SAP system ID */
        public Long id;
        /** Mode */
        public String infrastructureMode;
        /** [read-only] Installation number */
        public String installationNumber;
        /** SAP instances associated with the system (skipped in lists). If left not specified on UPDATE, the... */
        public java.util.List<SapInstance> instances;
        /** Automated inventory enabled */
        public Boolean inventoryEnabled;
        /** Equipment hosting Java central service */
        public ReferenceWithNameAndType javaCentralService;
        /** Java password */
        public String javaPassword;
        /** Java username */
        public String javaUsername;
        /** [read-only] Kernel compiled */
        public String kernelCompiled;
        /** [read-only] Kernel patch level */
        public String kernelPatchLevel;
        /** [read-only] Kernel release */
        public String kernelRelease;
        /** [read-only] Kind */
        public String kind;
        /** [read-only] Message produced by latest inventory */
        public String lastInventoryMessage;
        /** [read-only] Timestamp of latest inventory */
        public java.time.Instant lastInventoryTimestamp;
        /** [read-only] User who launched the latest inventory */
        public String lastInventoryUser;
        /** [read-only] Licence expiry date */
        public String licenceExpiry;
        /** SAP logon group */
        public String logonGroup;
        /** SAP logon group enabled */
        public Boolean logonGroupEnabled;
        /** SAP logon group port */
        public Integer logonGroupPort;
        /** Monitoring enabled. Default value: true */
        public Boolean monitoringEnabled;
        /** Organization */
        public ReferenceWithName organization;
        /** ABAP password */
        public String password;
        /** Region */
        public String region;
        /** Remarks */
        public String remarks;
        /** SAP router */
        public String router;
        /** [read-only] Rsyn */
        public String rsyn;
        /** Server name (cloud) */
        public String serverName;
        /** Enables/disables the use of Secured Network Communications (SNC) */
        public Boolean sncEnabled;
        /** Name of the secured network connection, that overrides the default secure network connection part... */
        public String sncMyName;
        /** SNC name of the Application Server, that acts os the SNC partner */
        public String sncPartnerName;
        /** Security level of the secured network connections */
        public String sncSecurityLevel;
        /** Stack type */
        public String stackType;
        /** [read-only] Supported databases */
        public String supportedDatabases;
        /** [read-only] Supported SAP versions */
        public String supportedSapVersions;
        /** SAP system ID */
        public String systemId;
        /** A list of tags associated to this SAP system */
        public java.util.List<ReferenceWithName> tags;
        /** Url tenant */
        public String tenant;
        /** The node type specific fields */
        public java.util.List<NodeTypeSpecificFieldLink> typeSpecificFields;
        /** [read-only] Unicode encoding? */
        public String unicode;
        /** Url */
        public String url;
        /** ABAP username */
        public String username;
        /** SAP System UUID */
        public String uuid;

        public static SapSystemWithInfo fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            SapSystemWithInfo res = new SapSystemWithInfo();
            res.abapCentralService = ReferenceWithNameAndType.fromJson(asObj(src.opt("abapCentralService")));
            res.abapLoadVersion = toStr(src.opt("abapLoadVersion"));
            res.authClientId = toStr(src.opt("authClientId"));
            res.authClientSecret = toStr(src.opt("authClientSecret"));
            res.authPassword = toStr(src.opt("authPassword"));
            res.authPort = toInt(src.opt("authPort"));
            res.authUser = toStr(src.opt("authUser"));
            res.authenticationMode = toStr(src.opt("authenticationMode"));
            res.clientId = toStr(src.opt("clientId"));
            res.components = SapComponentData.listFromJson(asArr(src.opt("components")));
            res.componentsVersion = toStr(src.opt("componentsVersion"));
            res.cuaLoadVersion = toStr(src.opt("cuaLoadVersion"));
            res.dbConnectionName = toStr(src.opt("dbConnectionName"));
            res.dbHost = toStr(src.opt("dbHost"));
            res.dbLibrary = toStr(src.opt("dbLibrary"));
            res.dbName = toStr(src.opt("dbName"));
            res.dbOwner = toStr(src.opt("dbOwner"));
            res.dbRelease = toStr(src.opt("dbRelease"));
            res.dbSize = toStr(src.opt("dbSize"));
            res.dbType = toStr(src.opt("dbType"));
            res.description = toStr(src.opt("description"));
            res.dialogUsersCount = toStr(src.opt("dialogUsersCount"));
            res.engine = ReferenceWithDescription.fromJson(asObj(src.opt("engine")));
            res.environment = ReferenceWithName.fromJson(asObj(src.opt("environment")));
            res.equipment = ReferenceWithNameAndType.fromJson(asObj(src.opt("equipment")));
            res.externalReference = toStr(src.opt("externalReference"));
            res.fingerprint = toStr(src.opt("fingerprint"));
            res.id = toLong(src.opt("id"));
            res.infrastructureMode = toStr(src.opt("infrastructureMode"));
            res.installationNumber = toStr(src.opt("installationNumber"));
            res.instances = SapInstance.listFromJson(asArr(src.opt("instances")));
            res.inventoryEnabled = toBool(src.opt("inventoryEnabled"));
            res.javaCentralService = ReferenceWithNameAndType.fromJson(asObj(src.opt("javaCentralService")));
            res.javaPassword = toStr(src.opt("javaPassword"));
            res.javaUsername = toStr(src.opt("javaUsername"));
            res.kernelCompiled = toStr(src.opt("kernelCompiled"));
            res.kernelPatchLevel = toStr(src.opt("kernelPatchLevel"));
            res.kernelRelease = toStr(src.opt("kernelRelease"));
            res.kind = toStr(src.opt("kind"));
            res.lastInventoryMessage = toStr(src.opt("lastInventoryMessage"));
            res.lastInventoryTimestamp = toDateTime(src.opt("lastInventoryTimestamp"));
            res.lastInventoryUser = toStr(src.opt("lastInventoryUser"));
            res.licenceExpiry = toStr(src.opt("licenceExpiry"));
            res.logonGroup = toStr(src.opt("logonGroup"));
            res.logonGroupEnabled = toBool(src.opt("logonGroupEnabled"));
            res.logonGroupPort = toInt(src.opt("logonGroupPort"));
            res.monitoringEnabled = toBool(src.opt("monitoringEnabled"));
            res.organization = ReferenceWithName.fromJson(asObj(src.opt("organization")));
            res.password = toStr(src.opt("password"));
            res.region = toStr(src.opt("region"));
            res.remarks = toStr(src.opt("remarks"));
            res.router = toStr(src.opt("router"));
            res.rsyn = toStr(src.opt("rsyn"));
            res.serverName = toStr(src.opt("serverName"));
            res.sncEnabled = toBool(src.opt("sncEnabled"));
            res.sncMyName = toStr(src.opt("sncMyName"));
            res.sncPartnerName = toStr(src.opt("sncPartnerName"));
            res.sncSecurityLevel = toStr(src.opt("sncSecurityLevel"));
            res.stackType = toStr(src.opt("stackType"));
            res.supportedDatabases = toStr(src.opt("supportedDatabases"));
            res.supportedSapVersions = toStr(src.opt("supportedSapVersions"));
            res.systemId = toStr(src.opt("systemId"));
            res.tags = ReferenceWithName.listFromJson(asArr(src.opt("tags")));
            res.tenant = toStr(src.opt("tenant"));
            res.typeSpecificFields = NodeTypeSpecificFieldLink.listFromJson(asArr(src.opt("typeSpecificFields")));
            res.unicode = toStr(src.opt("unicode"));
            res.url = toStr(src.opt("url"));
            res.username = toStr(src.opt("username"));
            res.uuid = toStr(src.opt("uuid"));
            return res;
        }

        public static java.util.List<SapSystemWithInfo> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Check threshold information */
    public static class Threshold {
        /** [read-only] Threshold message */
        public String message;
        /** [read-only] Threshold notification */
        public ReferenceWithDescription notification;
        /** [read-only] Threshold severity */
        public String severity;
        /** [read-only] Threshold team */
        public ReferenceWithName team;

        public static Threshold fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Threshold res = new Threshold();
            res.message = toStr(src.opt("message"));
            res.notification = ReferenceWithDescription.fromJson(asObj(src.opt("notification")));
            res.severity = toStr(src.opt("severity"));
            res.team = ReferenceWithName.fromJson(asObj(src.opt("team")));
            return res;
        }

        public static java.util.List<Threshold> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Alert log */
    public static class Log {
        /** [read-only] Details */
        public java.util.List<String> details;
        /** [read-only] Alert message */
        public String message;
        /** [read-only] Date/time of the alert */
        public java.time.Instant timestamp;
        /** [read-only] Value */
        public String value;

        public static Log fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Log res = new Log();
            res.details = list(asArr(src.opt("details")), CockpitItsmCore::toStr);
            res.message = toStr(src.opt("message"));
            res.timestamp = toDateTime(src.opt("timestamp"));
            res.value = toRaw(src.opt("value"));
            return res;
        }

        public static java.util.List<Log> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Check result */
    public static class CheckResult {
        /** [read-only] Last occurrence of the alert */
        public java.time.Instant date;
        /** [read-only] Alert logs attached to this alert message */
        public java.util.List<Log> logs;
        /** [read-only] Error code (0: Success) */
        public Integer status;

        public static CheckResult fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            CheckResult res = new CheckResult();
            res.date = toDateTime(src.opt("date"));
            res.logs = Log.listFromJson(asArr(src.opt("logs")));
            res.status = toInt(src.opt("status"));
            return res;
        }

        public static java.util.List<CheckResult> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Monitoring check information */
    public static class Check {
        /** [read-only] Check action document, if any */
        public ReferenceWithName actionDocument;
        /** [read-only] Check applications */
        public java.util.List<ReferenceWithName> applications;
        /** [read-only] Unique ID */
        public Long checkId;
        /** [read-only] Description of the parent if any */
        public String dependency;
        /** [read-only] Execute on parent success / failure */
        public String dependencyType;
        /** [read-only] Check details */
        public String details;
        /** [read-only] Alert display - Counter */
        public Integer displayCount;
        /** [read-only] Check engine */
        public ReferenceWithDescription engine;
        /** [read-only] Check environment */
        public ReferenceWithReference environment;
        /** [read-only] Check equipment */
        public ReferenceWithName equipment;
        /** [read-only] Check escalation document, if any */
        public ReferenceWithName escalationDocument;
        /** [read-only] Check first threshold */
        public Threshold firstThreshold;
        /** [read-only] Last alert message generated by this check */
        public CheckResult lastResult;
        /** [read-only] Timestamp of last update to this object */
        public java.time.Instant lastUpdateTimestamp;
        /** [read-only] Author of last update to this object */
        public String lastUpdateUser;
        /** [read-only] Check notes */
        public String notes;
        /** [read-only] Check organization (from it's equipment) */
        public ReferenceWithName organization;
        /** [read-only] ID of the parent check if any */
        public Long parentId;
        /** [read-only] Check schedule */
        public ReferenceWithDescription schedule;
        /** [read-only] Check second threshold, if any */
        public Threshold secondThreshold;
        /** [read-only] Status of the check */
        public String status;
        /** [read-only] Check subject */
        public String subject;
        /** [read-only] Check type (translated) */
        public String type;

        public static Check fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Check res = new Check();
            res.actionDocument = ReferenceWithName.fromJson(asObj(src.opt("actionDocument")));
            res.applications = ReferenceWithName.listFromJson(asArr(src.opt("applications")));
            res.checkId = toLong(src.opt("checkId"));
            res.dependency = toStr(src.opt("dependency"));
            res.dependencyType = toStr(src.opt("dependencyType"));
            res.details = toStr(src.opt("details"));
            res.displayCount = toInt(src.opt("displayCount"));
            res.engine = ReferenceWithDescription.fromJson(asObj(src.opt("engine")));
            res.environment = ReferenceWithReference.fromJson(asObj(src.opt("environment")));
            res.equipment = ReferenceWithName.fromJson(asObj(src.opt("equipment")));
            res.escalationDocument = ReferenceWithName.fromJson(asObj(src.opt("escalationDocument")));
            res.firstThreshold = Threshold.fromJson(asObj(src.opt("firstThreshold")));
            res.lastResult = CheckResult.fromJson(asObj(src.opt("lastResult")));
            res.lastUpdateTimestamp = toDateTime(src.opt("lastUpdateTimestamp"));
            res.lastUpdateUser = toStr(src.opt("lastUpdateUser"));
            res.notes = toStr(src.opt("notes"));
            res.organization = ReferenceWithName.fromJson(asObj(src.opt("organization")));
            res.parentId = toLong(src.opt("parentId"));
            res.schedule = ReferenceWithDescription.fromJson(asObj(src.opt("schedule")));
            res.secondThreshold = Threshold.fromJson(asObj(src.opt("secondThreshold")));
            res.status = toStr(src.opt("status"));
            res.subject = toStr(src.opt("subject"));
            res.type = toStr(src.opt("type"));
            return res;
        }

        public static java.util.List<Check> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** The organization data */
    public static class Organization {
        /** Activate auto-acknowledgment of extreme alerts in this organization */
        public Boolean autoAckExtremeAlerts;
        /** Activate auto-acknowledgment of high alerts in this organization */
        public Boolean autoAckHighAlerts;
        /** Activate auto-acknowledgment of info alerts in this organization */
        public Boolean autoAckInfoAlerts;
        /** Activate auto-acknowledgment of low alerts in this organization */
        public Boolean autoAckLowAlerts;
        /** Activate auto-acknowledgment of medium alerts in this organization */
        public Boolean autoAckMediumAlerts;
        /** Ticketing calls enabled for this organization */
        public Boolean callsEnabled;
        /** Ticket change requests catalog. Cannot be empty if changeRequestsEnabled is true */
        public ReferenceWithName changeRequestCatalog;
        /** Ticket change requests enabled for this organization */
        public Boolean changeRequestsEnabled;
        /** Communication module enabled for this organization */
        public Boolean communicationModuleEnabled;
        /** Document module enabled for this organization */
        public Boolean docModuleEnabled;
        /** The organization status (true if enabled) */
        public Boolean enabled;
        /** Id of the default engine for this organization. Required if inventoryInfraEnabled is true */
        public Long engineId;
        /** [read-only] Organization ID */
        public Long id;
        /** Ticket incidents catalog. Cannot be empty if incidentsEnabled is true */
        public ReferenceWithName incidentCatalog;
        /** Ticket incidents enabled for this organization */
        public Boolean incidentsEnabled;
        /** Infrastructure menu enabled for this organization */
        public Boolean inventoryInfraEnabled;
        /** Inventory module enabled for this organization */
        public Boolean inventoryModuleEnabled;
        /** Office menu enabled for this organization */
        public Boolean inventoryOfficeEnabled;
        /** Organization default language */
        public String language;
        /** Monitoring module enabled for this organization */
        public Boolean monitoringModuleEnabled;
        /** Name */
        public String name;
        /** Organization notes */
        public String notes;
        /** Password module enabled for this organization */
        public Boolean passwordModuleEnabled;
        /** Ticket problem catalog. Cannot be empty if problemsEnabled is true */
        public ReferenceWithName problemCatalog;
        /** Ticket problems enabled for this organization */
        public Boolean problemsEnabled;
        /** Ticket release catalog. Cannot be empty if releasesEnabled is true */
        public ReferenceWithName releaseCatalog;
        /** Ticket releases enabled for this organization */
        public Boolean releasesEnabled;
        /** Reporting module enabled for this organization */
        public Boolean reportingModuleEnabled;
        /** Ticket requests catalog. Cannot be empty if requestsEnabled is true */
        public ReferenceWithName requestCatalog;
        /** Ticket requests enabled for this organization */
        public Boolean requestsEnabled;
        /** A list of teams that access this organization */
        public java.util.List<ReferenceWithName> teams;
        /** Number of days to wait before auto-archiving tickets for this organization */
        public Integer ticketMustBeCompletedAfterDays;
        /** Ticket rating disabled/optional/mandatory for this organization */
        public String ticketRating;
        /** Ticketing module enabled for this organization */
        public Boolean ticketingModuleEnabled;
        /** Organization default time zone ID */
        public String timeZone;

        public static Organization fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Organization res = new Organization();
            res.autoAckExtremeAlerts = toBool(src.opt("autoAckExtremeAlerts"));
            res.autoAckHighAlerts = toBool(src.opt("autoAckHighAlerts"));
            res.autoAckInfoAlerts = toBool(src.opt("autoAckInfoAlerts"));
            res.autoAckLowAlerts = toBool(src.opt("autoAckLowAlerts"));
            res.autoAckMediumAlerts = toBool(src.opt("autoAckMediumAlerts"));
            res.callsEnabled = toBool(src.opt("callsEnabled"));
            res.changeRequestCatalog = ReferenceWithName.fromJson(asObj(src.opt("changeRequestCatalog")));
            res.changeRequestsEnabled = toBool(src.opt("changeRequestsEnabled"));
            res.communicationModuleEnabled = toBool(src.opt("communicationModuleEnabled"));
            res.docModuleEnabled = toBool(src.opt("docModuleEnabled"));
            res.enabled = toBool(src.opt("enabled"));
            res.engineId = toLong(src.opt("engineId"));
            res.id = toLong(src.opt("id"));
            res.incidentCatalog = ReferenceWithName.fromJson(asObj(src.opt("incidentCatalog")));
            res.incidentsEnabled = toBool(src.opt("incidentsEnabled"));
            res.inventoryInfraEnabled = toBool(src.opt("inventoryInfraEnabled"));
            res.inventoryModuleEnabled = toBool(src.opt("inventoryModuleEnabled"));
            res.inventoryOfficeEnabled = toBool(src.opt("inventoryOfficeEnabled"));
            res.language = toStr(src.opt("language"));
            res.monitoringModuleEnabled = toBool(src.opt("monitoringModuleEnabled"));
            res.name = toStr(src.opt("name"));
            res.notes = toStr(src.opt("notes"));
            res.passwordModuleEnabled = toBool(src.opt("passwordModuleEnabled"));
            res.problemCatalog = ReferenceWithName.fromJson(asObj(src.opt("problemCatalog")));
            res.problemsEnabled = toBool(src.opt("problemsEnabled"));
            res.releaseCatalog = ReferenceWithName.fromJson(asObj(src.opt("releaseCatalog")));
            res.releasesEnabled = toBool(src.opt("releasesEnabled"));
            res.reportingModuleEnabled = toBool(src.opt("reportingModuleEnabled"));
            res.requestCatalog = ReferenceWithName.fromJson(asObj(src.opt("requestCatalog")));
            res.requestsEnabled = toBool(src.opt("requestsEnabled"));
            res.teams = ReferenceWithName.listFromJson(asArr(src.opt("teams")));
            res.ticketMustBeCompletedAfterDays = toInt(src.opt("ticketMustBeCompletedAfterDays"));
            res.ticketRating = toStr(src.opt("ticketRating"));
            res.ticketingModuleEnabled = toBool(src.opt("ticketingModuleEnabled"));
            res.timeZone = toStr(src.opt("timeZone"));
            return res;
        }

        public static java.util.List<Organization> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    public static class EquipmentNodeSelection {
        public Boolean connectionPossible;
        /** [read-only] Description */
        public String description;
        /** [read-only] Environment ID */
        public Long environmentId;
        /** [read-only] Environment name */
        public String environmentName;
        /** Unique ID */
        public Long id;
        /** [read-only] Name */
        public String name;
        /** [read-only] Status description */
        public String status;
        /** [read-only] Structure ID */
        public Long structureId;
        /** [read-only] Structure name */
        public String structureName;
        /** [read-only] Type reference */
        public String type;
        /** [read-only] Translated type */
        public String typeDescription;
        /** [read-only] The equipment type ID */
        public Long typeId;

        public static EquipmentNodeSelection fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            EquipmentNodeSelection res = new EquipmentNodeSelection();
            res.connectionPossible = toBool(src.opt("connectionPossible"));
            res.description = toStr(src.opt("description"));
            res.environmentId = toLong(src.opt("environmentId"));
            res.environmentName = toStr(src.opt("environmentName"));
            res.id = toLong(src.opt("id"));
            res.name = toStr(src.opt("name"));
            res.status = toStr(src.opt("status"));
            res.structureId = toLong(src.opt("structureId"));
            res.structureName = toStr(src.opt("structureName"));
            res.type = toStr(src.opt("type"));
            res.typeDescription = toStr(src.opt("typeDescription"));
            res.typeId = toLong(src.opt("typeId"));
            return res;
        }

        public static java.util.List<EquipmentNodeSelection> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    public static class Connection {
        /** Downstream node */
        public EquipmentNodeSelection downstreamNode;
        /** Downstream port */
        public String downstreamPortLabel;
        /** Unique ID */
        public Long id;
        /** Link description */
        public String linkDescription;
        /** Relation description (upstream POV) */
        public String relation;
        /** Upstream node */
        public EquipmentNodeSelection upstreamNode;
        /** Upstream port */
        public String upstreamPortLabel;

        public static Connection fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            Connection res = new Connection();
            res.downstreamNode = EquipmentNodeSelection.fromJson(asObj(src.opt("downstreamNode")));
            res.downstreamPortLabel = toStr(src.opt("downstreamPortLabel"));
            res.id = toLong(src.opt("id"));
            res.linkDescription = toStr(src.opt("linkDescription"));
            res.relation = toStr(src.opt("relation"));
            res.upstreamNode = EquipmentNodeSelection.fromJson(asObj(src.opt("upstreamNode")));
            res.upstreamPortLabel = toStr(src.opt("upstreamPortLabel"));
            return res;
        }

        public static java.util.List<Connection> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }
    }

    /** Maintenance window data */
    public static class MaintenanceWindowExceptional {
        /** Checks to disengage */
        public java.util.List<Long> checkIds;
        /** [read-only] Timestamp of the object creation */
        public java.time.Instant creationTimestamp;
        /** [read-only] User who created the object */
        public String creationUser;
        /** Maintenance window description */
        public String description;
        /** The mode of disengagement. Must be set to CHECKS if checkIds is not empty, NODES or NODES_WITH_ME... */
        public String disengagementMode;
        /** End date. The attribute "timezone" does *not* have an impact on the interpretation of this timest... */
        public java.time.Instant endDate;
        /** Hci platforms to disengage */
        public java.util.List<Long> hciIds;
        /** [read-only] Unique ID */
        public Long id;
        /** [read-only] Timestamp of last update to this object */
        public java.time.Instant lastUpdateTimestamp;
        /** [read-only] User who last updated the object */
        public String lastUpdateUser;
        /** Networks to disengage */
        public java.util.List<Long> networkIds;
        /** Notes */
        public String notes;
        /** The organization */
        public ReferenceWithName organization;
        /** Servers to disengage */
        public java.util.List<Long> serverIds;
        /** Services affected by this maintenance window */
        public String serviceStatusImpact;
        /** Services affected by this maintenance window */
        public java.util.List<ReferenceWithName> services;
        /** Specific nodes to disengage */
        public java.util.List<Long> specificNodeIds;
        /** Start date. The attribute "timezone" does *not* have an impact on the interpretation of this time... */
        public java.time.Instant startDate;
        /** Storages to disengage */
        public java.util.List<Long> storageIds;
        /** The linked ticket Ids */
        public java.util.List<Long> ticketIds;
        /** Time zone ID */
        public String timeZone;

        public static MaintenanceWindowExceptional fromJson(JSONObject src) {
            if (src == null) {
                return null;
            }
            MaintenanceWindowExceptional res = new MaintenanceWindowExceptional();
            res.checkIds = list(asArr(src.opt("checkIds")), CockpitItsmCore::toLong);
            res.creationTimestamp = toDateTime(src.opt("creationTimestamp"));
            res.creationUser = toStr(src.opt("creationUser"));
            res.description = toStr(src.opt("description"));
            res.disengagementMode = toStr(src.opt("disengagementMode"));
            res.endDate = toDateTime(src.opt("endDate"));
            res.hciIds = list(asArr(src.opt("hciIds")), CockpitItsmCore::toLong);
            res.id = toLong(src.opt("id"));
            res.lastUpdateTimestamp = toDateTime(src.opt("lastUpdateTimestamp"));
            res.lastUpdateUser = toStr(src.opt("lastUpdateUser"));
            res.networkIds = list(asArr(src.opt("networkIds")), CockpitItsmCore::toLong);
            res.notes = toStr(src.opt("notes"));
            res.organization = ReferenceWithName.fromJson(asObj(src.opt("organization")));
            res.serverIds = list(asArr(src.opt("serverIds")), CockpitItsmCore::toLong);
            res.serviceStatusImpact = toStr(src.opt("serviceStatusImpact"));
            res.services = ReferenceWithName.listFromJson(asArr(src.opt("services")));
            res.specificNodeIds = list(asArr(src.opt("specificNodeIds")), CockpitItsmCore::toLong);
            res.startDate = toDateTime(src.opt("startDate"));
            res.storageIds = list(asArr(src.opt("storageIds")), CockpitItsmCore::toLong);
            res.ticketIds = list(asArr(src.opt("ticketIds")), CockpitItsmCore::toLong);
            res.timeZone = toStr(src.opt("timeZone"));
            return res;
        }

        public static java.util.List<MaintenanceWindowExceptional> listFromJson(JSONArray src) {
            return list(src, v -> fromJson(asObj(v)));
        }

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "checkIds", this.checkIds == null ? null : array(this.checkIds, x -> x));
            put(res, "description", this.description);
            put(res, "disengagementMode", this.disengagementMode);
            put(res, "endDate", this.endDate);
            put(res, "hciIds", this.hciIds == null ? null : array(this.hciIds, x -> x));
            put(res, "networkIds", this.networkIds == null ? null : array(this.networkIds, x -> x));
            put(res, "notes", this.notes);
            put(res, "organization", this.organization == null ? null : this.organization.toJson());
            put(res, "serverIds", this.serverIds == null ? null : array(this.serverIds, x -> x));
            put(res, "serviceStatusImpact", this.serviceStatusImpact);
            put(res, "services", this.services == null ? null : ReferenceWithName.listToJson(this.services));
            put(res, "specificNodeIds", this.specificNodeIds == null ? null : array(this.specificNodeIds, x -> x));
            put(res, "startDate", this.startDate);
            put(res, "storageIds", this.storageIds == null ? null : array(this.storageIds, x -> x));
            put(res, "ticketIds", this.ticketIds == null ? null : array(this.ticketIds, x -> x));
            put(res, "timeZone", this.timeZone);
            return res;
        }

        public static JSONArray listToJson(java.util.List<MaintenanceWindowExceptional> items) {
            return array(items, MaintenanceWindowExceptional::toJson);
        }
    }

    /** Sort */
    public static class Sort {
        /** Sort column */
        public String column;
        /** Sort direction. Default value: ASC */
        public String dir;

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "column", this.column);
            put(res, "dir", this.dir);
            return res;
        }

        public static JSONArray listToJson(java.util.List<Sort> items) {
            return array(items, Sort::toJson);
        }
    }

    /** The page request */
    public static class PageRequest {
        /** Number of requested page */
        public Integer page;
        /** Requested page size. Default value: 10 (empty value allowed) */
        public Integer pageSize;
        /** The sort criteria to be used in this request */
        public java.util.List<Sort> sort;

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "page", this.page);
            put(res, "pageSize", this.pageSize);
            put(res, "sort", this.sort == null ? null : Sort.listToJson(this.sort));
            return res;
        }

        public static JSONArray listToJson(java.util.List<PageRequest> items) {
            return array(items, PageRequest::toJson);
        }
    }

    /** The page request */
    public static class PageRequestWithSearch {
        /** The page request */
        public PageRequest pageRequest;
        /** The search query */
        public String query;

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            put(res, "pageRequest", this.pageRequest == null ? null : this.pageRequest.toJson());
            put(res, "query", this.query);
            return res;
        }

        public static JSONArray listToJson(java.util.List<PageRequestWithSearch> items) {
            return array(items, PageRequestWithSearch::toJson);
        }
    }

    /** SecuredData data */
    public static class Password {
        /** [read-only] A list of apps this password is associated with (skipped in lists). Filled only when individual p... */
        public java.util.List<ReferenceWithDescription> apps;
        /** The secure data additional data */
        public String data;
        /** [read-only] A list of databases this password is associated with (skipped in lists). Filled only when individ... */
        public java.util.List<ReferenceWithDescription> databases;
        /** Description */
        public String description;
        /** Expiration date */
        public java.time.Instant expirationDate;
        /** The number of days at which we send expiration notification (min: 1, max: 180) */
        public Integer expirationNotificationDelay;
        /** The folder this data belongs to */
        public ReferenceWithName folder;
        /** [read-only] A list of hci platforms this password is associated with (skipped in lists). Filled only when ind... */
        public java.util.List<ReferenceWithName> hciPlatforms;
        /** ID */
        public Long id;
        /** [read-only] A list of networks this password is associated with (skipped in lists). Filled only when individu... */
        public java.util.List<ReferenceWithName> networks;
        /** [read-only] A list of office equipments this password is associated with (skipped in lists). Filled only when... */
        public java.util.List<ReferenceWithDescription> officeEquipments;
        /** Organization (obsolete) */
        public ReferenceWithName organization;
        /** Passphrase (never displayed: write-only) */
        public String passphrase;
        /** [read-only] This flags indicates whether the password is protected by a passphrase */
        public Boolean passphraseProtected;
        /** Password (never displayed: write-only) */
        public String password;
        /** [read-only] A list of SAP systems this password is associated with (skipped in lists). Filled only when indiv... */
        public java.util.List<ReferenceWithDescription> sapSystems;
        /** [read-only] A list of servers this password is associated with (skipped in lists). Filled only when individua... */
        public java.util.List<ReferenceWithName> servers;
        /** [read-only] A list of specificNodes this password is associated with (skipped in lists). Filled only when ind... */
        public java.util.List<ReferenceWithName> specificNodes;
        /** [read-only] A list of storage this password is associated with (skipped in lists). Filled only when individua... */
        public java.util.List<ReferenceWithName> storage;
        /** Non-API object type: PASSWORD_TYPE */
        public ReferenceWithReference type;
        /** URL */
        public String url;
        /** Username */
        public String username;
        /** Non-API object type: VAULT_TYPE */
        public ReferenceWithName vault;

        public JSONObject toJson() {
            JSONObject res = new JSONObject();
            putRaw(res, "data", this.data);
            put(res, "description", this.description);
            put(res, "expirationDate", this.expirationDate);
            put(res, "expirationNotificationDelay", this.expirationNotificationDelay);
            put(res, "folder", this.folder == null ? null : this.folder.toJson());
            put(res, "id", this.id);
            put(res, "organization", this.organization == null ? null : this.organization.toJson());
            put(res, "passphrase", this.passphrase);
            put(res, "password", this.password);
            put(res, "type", this.type == null ? null : this.type.toJson());
            put(res, "url", this.url);
            put(res, "username", this.username);
            put(res, "vault", this.vault == null ? null : this.vault.toJson());
            return res;
        }

        public static JSONArray listToJson(java.util.List<Password> items) {
            return array(items, Password::toJson);
        }
    }

    // ---------------------------------------------------------------- endpoints

    /** GET /api/infrastructure/db/server/{dbServerId} - Get information about a DB server */
    public DatabaseServer getInfrastructureDbServer(long dbServerId) {
        return DatabaseServer.fromJson(asObj(callJson("GET", "/api/infrastructure/db/server/" + dbServerId, null)));
    }

    /** GET /api/infrastructure/equipment/{typeId}/{id} - Get information about an infrastructure equipment (Server, hci, storage, network or custom type) */
    public Equipment getInfrastructureEquipment(long typeId, long id) {
        return Equipment.fromJson(asObj(callJson("GET", "/api/infrastructure/equipment/" + typeId + "/" + id, null)));
    }

    /** GET /api/infrastructure/sap/system/{systemId} - Get information about a SAP system */
    public SapSystemWithInfo getInfrastructureSapSystem(long systemId) {
        return SapSystemWithInfo.fromJson(asObj(callJson("GET", "/api/infrastructure/sap/system/" + systemId, null)));
    }

    /** GET /api/monitoring/check/{id} - Fetch information about a check */
    public Check getMonitoringCheck(long id) {
        return Check.fromJson(asObj(callJson("GET", "/api/monitoring/check/" + id, null)));
    }

    /** GET /api/organization/by-name - Get an organization by name */
    public Organization getOrganizationByName(String name) {
        StringBuilder q = new StringBuilder();
        if (name != null) {
            addQuery(q, "name", name);
        }
        return Organization.fromJson(asObj(callJson("GET", "/api/organization/by-name" + q, null)));
    }

    /** POST /api/infrastructure/relationships/list - List infrastructure relationships (all pages), no criteria */
    public java.util.List<Connection> listInfrastructureRelationships() {
        return listInfrastructureRelationships((PageRequestWithSearch) null);
    }

    /** POST /api/infrastructure/relationships/list - List infrastructure relationships (all pages) */
    public java.util.List<Connection> listInfrastructureRelationships(PageRequestWithSearch criteria) {
        JSONObject body = criteria == null ? new JSONObject() : criteria.toJson();
        return Connection.listFromJson(fetchAllPages("POST", "/api/infrastructure/relationships/list", body, "pageRequest"));
    }

    /** POST /api/monitoring/exceptional-maintenance-window - Create a new exceptional maintenance window */
    public MaintenanceWindowExceptional postMonitoringExceptionalMaintenanceWindow(MaintenanceWindowExceptional maintenanceWindowExceptional) {
        return MaintenanceWindowExceptional.fromJson(asObj(callJson("POST", "/api/monitoring/exceptional-maintenance-window", maintenanceWindowExceptional.toJson().toString())));
    }

    /** POST /api/secured-data/{id} - Update an existing secured data */
    public String postSecuredDataById(long id, Password password) {
        return call("POST", "/api/secured-data/" + id, password.toJson().toString());
    }

    /** POST /api/secured-data/{id}/decrypt - Decrypt a secured data. */
    public String postSecuredDataDecrypt(long id, String text) {
        return call("POST", "/api/secured-data/" + id + "/decrypt", text);
    }

    /** PUT /api/monitoring/exceptional-maintenance-window - Update an existing exceptional maintenance window */
    public MaintenanceWindowExceptional putMonitoringExceptionalMaintenanceWindow(MaintenanceWindowExceptional maintenanceWindowExceptional) {
        return MaintenanceWindowExceptional.fromJson(asObj(callJson("PUT", "/api/monitoring/exceptional-maintenance-window", maintenanceWindowExceptional.toJson().toString())));
    }
}
