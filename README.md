# Cloudflare Terraform Rules Demo

这个项目使用 Terraform 管理 Cloudflare 的安全规则和速率限制规则。

## 文件结构

- `provider.tf` - Terraform provider 配置
- `variables.tf` - 变量定义
- `ruleset.tf` - 主要的规则集配置
- `terraform.tfvars` - 实际的变量值（包含敏感信息，不应提交到版本控制）
- `terraform.tfvars.example` - 变量值模板
- `.gitignore` - Git 忽略文件配置

## 配置的规则

### 1. Zone Custom Firewall Rules
- 阻止来自 AX 国家的流量
- 返回 403 状态码和自定义消息
- 直接在 Cloudflare 界面中可见

### 2. Rate Limiting Rules
- 针对 mytv163 user agent 的速率限制
- 15 秒内最多 10 个请求
- 基于 colocation ID 和源 IP 进行限制

## 使用方法

1. 复制变量模板文件：
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. 编辑 `terraform.tfvars` 文件，填入你的实际值：
   ```hcl
   cloudflare_api_token = "your_actual_api_token"
   cloudflare_zone_id   = "your_actual_zone_id"
   ```

3. 初始化 Terraform：
   ```bash
   terraform init
   ```

4. 查看执行计划：
   ```bash
   terraform plan
   ```

5. 应用配置：
   ```bash
   terraform apply
   ```

## 安全注意事项

- `terraform.tfvars` 文件包含敏感信息，已添加到 `.gitignore` 中
- API Token 应该具有适当的权限范围
- 建议使用环境变量或 Terraform Cloud 来管理敏感变量

## API Token 权限要求

为了成功管理 Cloudflare 规则集，你的 API Token 需要以下权限：

- **Zone > Zone WAF** 权限（或更广泛的权限）
- **Zone > Zone** 权限（用于读取 zone 信息）

创建 API Token 时，请确保：
1. 在 Cloudflare Dashboard 中访问 "My Profile" > "API Tokens"
2. 点击 "Create Token"
3. 选择 "Custom token" 模板
4. 添加以下权限：
   - Zone:Zone WAF:Edit
   - Zone:Zone:Read
5. 指定适当的 Zone Resources（可以选择特定 zone 或所有 zone）

**注意**: 这些 API 调用代表了上述所有更改。需要具有 `Zone > Zone WAF` 或更广泛权限的 API Token。

## 变量说明

- `cloudflare_api_token` - Cloudflare API Token（必需，敏感）
- `cloudflare_zone_id` - Cloudflare Zone ID（必需）
- `cloudflare_account_id` - Cloudflare Account ID（可选，用于账户级资源）