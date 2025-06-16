resource "google_bigquery_dataset" "lynx" {
  dataset_id = "lynx"
  project    = var.project_id
  location   = "europe-west3"
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "events"

  schema = jsonencode([
    { name = "userPseudoId", type = "STRING", mode = "NULLABLE" },
    { name = "sessionId",    type = "INT64",  mode = "NULLABLE" },
    { name = "eventName",    type = "STRING", mode = "NULLABLE" },
    { name = "hostname",     type = "STRING", mode = "NULLABLE" },
    { name = "eventDate",    type = "TIMESTAMP", mode = "NULLABLE" },

    {
      name = "user"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "id",         type = "STRING",    mode = "NULLABLE" },
        { name = "email",      type = "STRING",    mode = "NULLABLE" },
        { name = "firstName",  type = "STRING",    mode = "NULLABLE" },
        { name = "lastName",   type = "STRING",    mode = "NULLABLE" },
        { name = "birthDate",  type = "TIMESTAMP", mode = "NULLABLE" },
        { name = "zip",        type = "STRING",    mode = "NULLABLE" },
        { name = "city",       type = "STRING",    mode = "NULLABLE" },
        { name = "country",    type = "STRING",    mode = "NULLABLE" },
        { name = "phone",      type = "STRING",    mode = "NULLABLE" },
        { name = "customerId", type = "STRING",    mode = "NULLABLE" },
        { name = "creationDate", type = "TIMESTAMP", mode = "NULLABLE" },
        { name = "lastUpdate",   type = "TIMESTAMP", mode = "NULLABLE" },
      ]
    },

    {
      name = "device"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "userPseudoId", type = "STRING", mode = "NULLABLE" },
        {
          name = "browserId"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            { name = "meta",    type = "STRING", mode = "NULLABLE" },
            { name = "tikTok",  type = "STRING", mode = "NULLABLE" },
          ]
        },
      ]
    },

    {
      name = "consent"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "adStorage",           type = "STRING", mode = "NULLABLE" },
        { name = "adUserData",          type = "STRING", mode = "NULLABLE" },
        { name = "adPersonalization",   type = "STRING", mode = "NULLABLE" },
        { name = "analyticsStorage",    type = "STRING", mode = "NULLABLE" },
        { name = "functionalityStorage",type = "STRING", mode = "NULLABLE" },
        { name = "personalizationStorage", type = "STRING", mode = "NULLABLE" },
        { name = "securityStorage",     type = "STRING", mode = "NULLABLE" },
      ]
    },

    { name = "userAgent", type = "STRING", mode = "NULLABLE" },

    { name = "LANGUAGE",         type = "STRING",    mode = "NULLABLE" },
    { name = "screenResolution", type = "STRING",    mode = "NULLABLE" },
    { name = "ipAddress",        type = "STRING",    mode = "NULLABLE" },
    { name = "creationDate",     type = "TIMESTAMP", mode = "NULLABLE" },
    { name = "lastUpdate",       type = "TIMESTAMP", mode = "NULLABLE" },

    {
      name = "session"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "id",          type = "INT64", mode = "NULLABLE" },
        { name = "number",      type = "INT64", mode = "NULLABLE" },
        { name = "engagedTime", type = "INT64", mode = "NULLABLE" },
        {
          name = "clickParameter"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            { name = "meta",        type = "STRING", mode = "NULLABLE" },
            { name = "google",      type = "STRING", mode = "NULLABLE" },
            { name = "tikTok",      type = "STRING", mode = "NULLABLE" },
            { name = "microsoftAds",type = "STRING", mode = "NULLABLE" },
            { name = "pinterest",   type = "STRING", mode = "NULLABLE" },
            { name = "taboola",     type = "STRING", mode = "NULLABLE" },
          ]
        },
      ]
    },

    {
      name = "ad"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "SOURCE",   type = "STRING", mode = "NULLABLE" },
        { name = "medium",   type = "STRING", mode = "NULLABLE" },
        { name = "campaign", type = "STRING", mode = "NULLABLE" },
        { name = "content",  type = "STRING", mode = "NULLABLE" },
        { name = "term",     type = "STRING", mode = "NULLABLE" },
      ]
    },

    {
      name = "event"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "id",           type = "STRING",    mode = "NULLABLE" },
        { name = "name",         type = "STRING",    mode = "NULLABLE" },
        { name = "hostname",     type = "STRING",    mode = "NULLABLE" },
        { name = "pageLocation", type = "STRING",    mode = "NULLABLE" },
        { name = "pageReferrer", type = "STRING",    mode = "NULLABLE" },
        { name = "pageTitle",    type = "STRING",    mode = "NULLABLE" },
        { name = "entity",       type = "STRING",    mode = "NULLABLE" },
        { name = "action",       type = "STRING",    mode = "NULLABLE" },
        { name = "price",        type = "FLOAT64",   mode = "NULLABLE" },
        { name = "currency",     type = "STRING",    mode = "NULLABLE" },
        {
          name = "params"
          type = "RECORD"
          mode = "REPEATED"
          fields = [
            { name = "KEY",   type = "STRING", mode = "NULLABLE" },
            { name = "value", type = "STRING", mode = "NULLABLE" },
          ]
        },
        {
          name = "items"
          type = "RECORD"
          mode = "REPEATED"
          fields = [
            { name = "id",         type = "STRING",    mode = "NULLABLE" },
            { name = "name",       type = "STRING",    mode = "NULLABLE" },
            { name = "price",      type = "FLOAT64",   mode = "NULLABLE" },
            { name = "quantity",   type = "INT64",     mode = "NULLABLE" },
            { name = "categories", type = "STRING",    mode = "REPEATED" },
          ]
        },
        { name = "creationDate", type = "TIMESTAMP", mode = "NULLABLE" },
      ]
    },
  ])

  time_partitioning {
    type  = "DAY"
    field = "eventDate"
  }

  clustering = [
      "eventName",
      "userPseudoId",
      "sessionId",
      "hostname",
    ]

  description = "A table to store the event information. The structures are user, device, session and events, partitioned by event creation date and clustered by userPseudoId, sessionId, eventName and hostname"
}

resource "google_bigquery_table" "logging" {
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "logging"

  schema = jsonencode([
    { name = "eventName",    type = "STRING",    mode = "NULLABLE" },
    { name = "event",        type = "STRING",    mode = "NULLABLE" },
    { name = "encodedEvent", type = "STRING",    mode = "NULLABLE" },
    { name = "headers",      type = "STRING",    mode = "NULLABLE" },
    { name = "eventDate",    type = "TIMESTAMP", mode = "NULLABLE" }
  ])

  time_partitioning {
    type          = "DAY"
    field         = "eventDate"
    expiration_ms = 7 * 24 * 60 * 60 * 1000   # 7 Tage
  }

  clustering = ["eventName"]

  description = "A table to store the untouched event information."
}

resource "google_bigquery_table" "user_mails" {
  provider   = google-beta
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "userMails"

  materialized_view {
    query = <<-SQL
      SELECT DISTINCT user.email, eventName
      FROM `${var.project_id}.lynx.events`
      WHERE eventName IN ('generateLead', 'purchase')
        AND user.email IS NOT NULL
    SQL
    enable_refresh           = true
    refresh_interval_ms      = 1440 * 60 * 1000
  }

  description = "View to identify users who have generated a lead or made a purchase"
}
