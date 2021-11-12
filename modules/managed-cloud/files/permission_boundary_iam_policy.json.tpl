{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AllowedServices",
			"Effect": "Allow",
			"Action": [
			    "acm:*",
			    "autoscaling:*",
			    "cognito-idp:*",
			    "dynamodb:*",
			    "ec2:*",
			    "ecr:*",
			    "eks:*",
			    "elasticloadbalancing:*",
			    "iam:GetInstanceProfile",
			    "iam:GetOpenIDConnectProvider",
			    "iam:GetPolicy",
			    "iam:GetPolicyVersion",
			    "iam:GetRole",
			    "iam:GetServerCertificate",
			    "iam:ListAttachedRolePolicies",
			    "iam:ListEntitiesForPolicy",
			    "iam:ListInstanceProfile*",
			    "iam:ListOpenIDConnectProvider*",
			    "iam:ListPolicies",
			    "iam:ListPolicyTags",
			    "iam:ListPolicyVersions",
			    "iam:ListRole*",
			    "iam:ListServerCertificates",
			    "kms:*",
			    "logs:*",
			    "route53:*",
			    "s3:*",
			    "shield:*",
			    "sts:*",
			    "waf-regional:*",
			    "wafv2:*"
			],
			"Resource": "*"
		},
		{
			"Sid": "IamRestrictions",
			"Effect": "Allow",
			"Action": [
				"iam:AddRoleToInstanceProfile",
				"iam:AttachRolePolicy",
				"iam:CreateOpenIDConnectProvider",
				"iam:CreatePolicy",
				"iam:CreatePolicyVersion",
				"iam:CreateRole",
				"iam:CreateServiceLinkedRole",
				"iam:DeleteInstanceProfile",
				"iam:DeleteOpenIDConnectProvider",
				"iam:DeletePolicy",
				"iam:DeletePolicyVersion",
				"iam:DeleteRole",
				"iam:DeleteServiceLinkedRole",
				"iam:DetachRolePolicy",
				"iam:PassRole",
				"iam:PutRolePermissionsBoundary",
				"iam:RemoveRoleFromInstanceProfile",
				"iam:SetDefaultPolicyVersion",
				"iam:TagInstanceProfile",
				"iam:TagOpenIDConnectProvider",
				"iam:TagPolicy",
				"iam:TagRole",
				"iam:UpdateAssumeRolePolicy",
				"iam:UpdateOpenIDConnectProviderThumbprint",
				"iam:UpdateRole",
				"iam:UpdateRoleDescription"
			],
			"Resource": [
				"arn:aws:iam::aws:policy/*",
				"arn:aws:iam::${account_id}:role/StreamNative/*",
				"arn:aws:iam::${account_id}:policy/StreamNative/*",
				"arn:aws:iam::${account_id}:oidc-provider/*",
				"arn:aws:iam::${account_id}:instance-profile/*",
				"arn:aws:iam::${account_id}:server-certificate/*"
			]
		},
		{
			"Sid": "RestrictPassRoleToEKS",
			"Effect": "Allow",
			"Action": [
				"iam:PassRole"
			],
			"Resource": "arn:aws:iam::${account_id}:role/StreamNative/*",
			"Condition": {
				"StringEquals": {
					"iam:PassedToService": "eks.amazonaws.com"
				}
			}
		},
		{
			"Sid": "AllowedIAMManagedPolicies",
			"Effect": "Deny",
			"Action": [
				"iam:AttachRolePolicy"
			],
			"Resource": "arn:aws:iam::${account_id}:role/StreamNative/*",
			"Condition": {
				"ArnNotLike": {
					"iam:PolicyARN": [ 
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudAWSLoadBalancerControllerPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudCertManagerPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudClusterAutoscalerPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudCsiPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudExternalDnsPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudExternalSecretsPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudPermissionBoundary",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudTieredStoragePolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudVaultPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/StreamNativeCloudVeleroBackupPolicy",
						"arn:aws:iam::${account_id}:policy/StreamNative/*-elb-sl-role-*",
						"arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
						"arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
						"arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
						"arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
						"arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
						"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
					]
				}
			}
		},
		{
			"Sid": "RequirePermissionBoundaryForIamRoles",
			"Effect": "Allow",
			"Action": [
				"iam:CreateRole"
			],
			"Resource": "arn:aws:iam::${account_id}:role/StreamNative/*",
			"Condition": {
				"StringEqualsIgnoreCase": {
					"aws:ResourceTag/Vendor": "StreamNative",
					"iam:PermissionsBoundary": "arn:aws:iam:::policy/StreamNative/StreamNativeCloudPermissionBoundary"
				}
			}
		},
		{
			"Sid": "RestrictChangesToVendorAccess",
			"Effect": "Deny",
			"Action": [
				"iam:Attach",
				"iam:Create*",
				"iam:Delete*",
				"iam:Put",
				"iam:Tag*",
				"iam:Untag*",
				"iam:Update*",
				"iam:Set*"
			],
			"Resource": [
				"arn:aws:iam:::policy/StreamNative/StreamNativeCloudPermissionBoundary",
				"arn:aws:iam::${account_id}:role/StreamNative/StreamNativeBootstrapRole",
				"arn:aws:iam::${account_id}:role/StreamNative/StreamNativeManagementRole"
			]
		}
	]
}