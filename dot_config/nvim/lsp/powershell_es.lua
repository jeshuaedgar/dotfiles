return {
	cmd = {
		"pwsh",
		"-NoLogo",
		"-NoProfile",
		"-Command",
		"Import-Module PowerShellEditorServices; Start-EditorServices "
			.. "-HostName nvim -HostProfileId 0 -HostVersion 1.0.0 "
			.. "-LogPath /tmp/pses.log -LogLevel Normal "
			.. "-BundledModulesPath '' -Stdio",
	},
	filetypes = { "ps1", "psm1", "psd1" },
	root_markers = { ".git" },
	settings = {
		powershell = {
			codeFormatting = {
				Preset = "Stroustrup",
				alignPropertyValuePairs = true,
				whitespaceBeforeOpenParen = true,
				whitespaceBeforeOpenBrace = true,
				whitespaceAroundOperator = true,
				whitespaceAfterSeparator = true,
				whitespaceBetweenParameters = true,
				ignoreOneLineBlock = true,
				addWhitespaceAroundPipe = true,
				trimWhitespaceAroundPipe = true,
				autoCorrectAliases = true,
				whitespaceInsideBrace = false,
			},
		},
	},
}
