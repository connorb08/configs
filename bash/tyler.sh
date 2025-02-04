
# EERPDEV functions
function startDatabase() {
   local container_name="eerpdev-eerp-core-sql-server-sqlserver-1"

   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" == "running" ]; then
      echo "$container_name is already running"
   else
      echo "starting $container_name"
      (&>/dev/null eerpdev sql-server start-container --sa-password 'Password1' --detach &)
   fi
}

function killDatabase() {
   local container_name="eerpdev-eerp-core-sql-server-sqlserver-1"

   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" != "running" ]; then
      echo "$container_name is already stopped"
   else
      echo "stopping $container_name"
      (&>/dev/null eerpdev sql-server stop-container &)
   fi
}

function startGAS() {
   local container_name="eerpdev-eerp-core-genero-application-server-runtime-1"
   
   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" == "running" ]; then
      echo "$container_name is already running"
   else
      echo "starting $container_name"
      (&>/dev/null eerpdev gas start-container --detach &)
   fi
}

function killGas() {
   local container_name="eerpdev-eerp-core-genero-application-server-runtime-1"
   
   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" != "running" ]; then
      echo "$container_name is already stopped"
   else
      echo "stopping $container_name"
      (&>/dev/null eerpdev gas stop-container &)
   fi
}

function startBuild() {
   local container_name="eerpdev-eerp-core-build-build-1"
   
   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" == "running" ]; then
      echo "$container_name is already running"
   else
      echo "starting $container_name"
      (&>/dev/null eerpdev build start-container &)
   fi
}

function killBuild() {
   local container_name="eerpdev-eerp-core-build-build-1"
   
   if [ "$(docker container inspect --format '{{.State.Status}}' $container_name 2>&1)" != "running" ]; then
      echo "$container_name is already stopped"
   else
      echo "stopping $container_name"
      (&>/dev/null eerpdev build stop-container &)
   fi
}

function startServices() {
   startDatabase
   startGAS
   startBuild
}

function killServices() {
   killDatabase
   killGas
   killBuild
}

# Autocomplete for database restore
function _restoreDatabase {
   local cur=${COMP_WORDS[COMP_CWORD]}
   COMPREPLY=($(compgen -W "$(ls /mnt/user-data/sqlserver/backups)" -- $cur))
}

complete -F _restoreDatabase restoreDatabase

function restoreDatabase {
   eerpdev sql-server restore-database eerp.dev $1
}

# Khatahdin functions
function generateGraph() {
   eerpdev genero-code-analysis write-dependency-graph
}

function getTaxPrograms() {
   eerpdev katahdin get-untranslated-modules tx --count --exclude-translated-applications
}

function getAllTaxPrograms() {
   eerpdev katahdin get-untranslated-modules tl --count --exclude-translated-applications
   eerpdev katahdin get-untranslated-modules tm --count --exclude-translated-applications
   eerpdev katahdin get-untranslated-modules tn --count --exclude-translated-applications
   eerpdev katahdin get-untranslated-modules ts --count --exclude-translated-applications
   eerpdev katahdin get-untranslated-modules tt --count --exclude-translated-applications
   eerpdev katahdin get-untranslated-modules vr --count --exclude-translated-applications
}

function getDeps() {
   eerpdev katahdin get-remaining-program-dependencies $1
}

function analyzeTranslation() {
   eerpdev katahdin generate-translation-analysis $1
}

function reverseDeps() {
   eerpdev genero-code-analysis get-module-dependencies --reverse $1
}