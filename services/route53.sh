#!/bin/bash
# AWS Route53

function peco_aws_route53_list() {
	commandline="aws route53 list-hosted-zones \
		--query '*[].{AId:Id,Name:Name}' --output text | tr -s '\t' '_'"
	peco_commandline_input ${commandline} 'true'
}

function aws_route53_list() {
	aws_run_commandline "\
		aws route53 list-hosted-zones --query \
			'*[].{Id:Id,Name:Name,PrivateZone:Config.PrivateZone}' --output table
	"
}

function aws_route53_get_host_zone() {
	aws_route53_host_zone_id=$1

	aws_run_commandline "\
		aws route53 list-resource-record-sets \
			--hosted-zone-id ${aws_route53_host_zone_id:?'aws_route53_host_zone_id is unset or empty'} \
			--query 'ResourceRecordSets[].{ \
				Name:Name,Type:Type,\
				AliasTarget:AliasTarget.DNSName, \
				ResourceRecords:ResourceRecords, \
				ResourceRecords:ResourceRecords[0].Value}' \
			--output table
	"
}

function aws_route53_get() {
	aws_route53_get_host_zone $1
}

function aws_route53_get_with_hint() {

	local lhs_input=$(peco_create_menu 'peco_aws_route53_list' '--prompt "Choose the domain >"')
	local aws_route53_host_zone_id=$(echo ${lhs_input} | awk -F "_" '{print $1}')
	aws_route53_get $aws_route53_host_zone_id
}

function aws_route_get_host_zone_with_hint() {

	local lhs_input=$(peco_create_menu 'peco_aws_route53_list' '--prompt "Choose the domain >"')
	local aws_route53_host_zone_id=$(echo ${lhs_input} | awk -F "_" '{print $1}')

	aws route53 get-hosted-zone --id ${aws_route53_host_zone_id}

}
