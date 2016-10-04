# Number of seconds to wait for Jenkins to become ready after start/restart/reload
default['jenkins']['executor']['timeout'] = 300

# Default JVM options to pass to Jenkins master; setting it not run setup wizard by default
default['jenkins']['master']['jvm_options'] = '-Djenkins.install.runSetupWizard=false'

# Confirm plugins node attribute array exists
default['jenkins_ci']['jenkins']['plugins'] = [] if default['jenkins_ci']['jenkins']['plugins'].nil

# plugins to allow code pull for jobs from git / github
default['jenkins_ci']['jenkins']['plugins'] += [
  'scm-api',
  'git-client',
  'git-server',
  'git',
  'github',
  'github-api',
  'github-oauth',
  'pollscm'
]

# common optional dependencies
default['jenkins_ci']['jenkins']['plugins'] += [
  'ant',
  'javadoc',
  'maven-plugin'
]

# colourises console output, instead of displaying literal ansi escape sequences
default['jenkins_ci']['jenkins']['plugins'] << 'ansicolor'

# adds reusable macro expansion capability for other plugins to use
default['jenkins_ci']['jenkins']['plugins'] << 'token-macro'

# You can use this plugin to enable docker for kitchen tests in your wrapper cookbook if you please
# DISABLED_PLUGIN #default['jenkins_ci']['jenkins']['plugins'] << 'config-file-provider'

# lets us parse console output to report on warnings.
# used to extract foodcritic's complaints, per the
# instructions on http://acrmp.github.io/foodcritic/#ci
default['jenkins_ci']['jenkins']['plugins'] += [
  'analysis-core',
  'dashboard-view',
  'warnings'
]

# ssh forwarding agent
default['jenkins_ci']['jenkins']['plugins'] << 'ssh-agent'

# build pipelines, notifications, and displays
default['jenkins_ci']['jenkins']['plugins'] += [
  'matrix-auth',
  'ez-templates',
  'jenkins-multijob-plugin',
  'build-pipeline-plugin',
  'buildresult-trigger',
  'embeddable-build-status',
  'promoted-builds',
  'promoted-builds-simple',
  'workflow-aggregator',
  'slack',
  'email-ext',
  'jenkinswalldisplay'
]
