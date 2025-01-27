{{/*
Generates the command for popeye
*/}}
{{- define "popeyeCmd" -}}
{{- $cmd := "popeye"}}

{{- if .popeyeConfiguration}}
    {{- $cmd = cat $cmd  "-f /etc/config/popeye/spinach.yml" }}
{{- end }}

{{- $cmd = cat $cmd "--force-exit-zero=true"}}

{{- if $.cronJob.containerConfiguration.allNamespaces}}
    {{- $cmd = cat $cmd  "--all-namespaces" }}
{{- end }}

{{- if $.cronJob.containerConfiguration.logLevel}}
    {{- $cmd = cat $cmd (printf "%s%d" "--log-level=" ($.cronJob.containerConfiguration.logLevel | int))}}
{{- end }}

{{- $cmd = cat $cmd (printf "%s%s" "--out=" $.cronJob.containerConfiguration.outputFormat)}} 

{{- if and (eq .cronJob.containerConfiguration.outputFormat "prometheus") (.cronJob.containerConfiguration.prometheus.address) }}
{{- $cmd = cat $cmd (printf "%s%s" "--push-gtwy-url=" $.cronJob.containerConfiguration.prometheus.address)}}
    {{- if .cronJob.containerConfiguration.prometheus.basicAuth.enabled }}
    {{- $cmd = cat $cmd (printf "%s%s" "--push-gtwy-user=" $.cronJob.containerConfiguration.prometheus.basicAuth.user)}}
    {{- $cmd = cat $cmd "--push-gtwy-password=$PROM_BASIC_AUTH_PW"}}
{{- end }}
{{- end }}

{{- printf $cmd -}}
{{- end }}