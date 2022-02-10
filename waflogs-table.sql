CREATE EXTERNAL TABLE `waf_logs_partition`(
  `timestamp` bigint,
  `formatversion` int,
  `webaclid` string,
  `terminatingruleid` string,
  `terminatingruletype` string,
  `action` string,
  `terminatingrulematchdetails` array<
                                  struct<
                                    conditiontype:string,
                                    location:string,
                                    matcheddata:array<string>
                                        >
                                     >,
  `httpsourcename` string,
  `httpsourceid` string,
  `rulegrouplist` array<
                     struct<
                        rulegroupid:string,
                        terminatingrule:struct<
                           ruleid:string,
                           action:string,
                           rulematchdetails:string
                                               >,
                        nonterminatingmatchingrules:array<
                                                       struct<
                                                          ruleid:string,
                                                          action:string,
                                                          rulematchdetails:array<
                                                               struct<
                                                                  conditiontype:string,
                                                                  location:string,
                                                                  matcheddata:array<string>
                                                                     >
                                                                  >
                                                               >
                                                            >,
                        excludedrules:array<
                                         struct<
                                            ruleid:string,
                                            exclusiontype:string
                                               >
                                            >
                           >
                       >,
  `ratebasedrulelist` array<
                        struct<
                          ratebasedruleid:string,
                          limitkey:string,
                          maxrateallowed:int
                              >
                           >,
  `nonterminatingmatchingrules` array<
                                  struct<
                                    ruleid:string,
                                    action:string
                                        >
                                     >,
  `requestheadersinserted` string,
  `responsecodesent` string,
  `httprequest` struct<
                      clientip:string,
                      country:string,
                      headers:array<
                                struct<
                                  name:string,
                                  value:string
                                      >
                                   >,
                      uri:string,
                      args:string,
                      httpversion:string,
                      httpmethod:string,
                      requestid:string
                      >,
  `labels` array<
             struct<
               name:string
                   >
                  >
)
PARTITIONED BY
(
 day STRING
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://aws-waf-logs-cyijhong/'
TBLPROPERTIES
(
 "projection.enabled" = "true",
 "projection.day.type" = "date",
 "projection.day.range" = "2021/11/01,NOW",
 "projection.day.format" = "yyyy/MM/dd",
 "projection.day.interval" = "1",
 "projection.day.interval.unit" = "DAYS",
 "storage.location.template" = "s3://aws-waf-logs-cyijhong/${day}"
)