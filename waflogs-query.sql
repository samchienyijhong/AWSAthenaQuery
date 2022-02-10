SELECT
    from_unixtime(timestamp / 1000e0) AS time,
    terminatingruletype,
    httpSourceName,
    httprequest.clientIp,
    httprequest.httpMethod,
    httprequest.headers,
    httprequest.uri,
    httprequest.args,
    responseCodeSent,
    terminatingRuleId,
    action,
    rg.ruleGroupId,
    rg.excludedRules,
    rg.terminatingRule.ruleId AS ruleGroupTerminatingRuelId,
    rg.terminatingRule.action AS ruleGroupTerminatingRuleAction,
    ntmr.ruleid AS nonTerminatingMatchingRuleId,
    ntmr.action AS nonTerminatingMatchingRuleAction,
    ntmrmd.conditionType AS nonTerminatingMatchingRuleCondintionType,
    ntmrmd.location AS nonTerminatingMatchingRuleLocation,
    ntmrmd.matcheddata AS nonTerminatingMatchingRuleData
FROM waf_logs
CROSS JOIN UNNEST(rulegrouplist) AS t(rg)
CROSS JOIN UNNEST(nonterminatingmatchingrules) AS t(ntmr)
CROSS JOIN UNNEST(IF(CARDINALITY(ntmr.rulematchdetails) = 0, ARRAY[NULL], ntmr.rulematchdetails)) AS t(ntmrmd)
WHERE rg.terminatingrule.ruleid <> ''
ORDER BY time DESC