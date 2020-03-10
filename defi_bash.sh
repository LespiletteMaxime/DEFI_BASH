 #!/bin/bash

# defi_bash.sh: va créer une page internet avec des photos, afin de créer un diaporama

# ALBUM_NAME: Nom de l'album
ALBUM_NAME=$1;

# PATH_TO_IMG: Chemin des images de base
PATH_TO_IMG=$2;

# PATH_TO_ALBUM: Le chemin complet de l'album
PATH_TO_ALBUM="${HOME}/Albums/${ALBUM_NAME}/";

# SCRIPT_PATH: Chemin absolu du script.sh
#SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
SCRIPT_PATH=$(pwd)

stop_script(){
	echo "Arrêt du script !";
	exit;
}

# NOTE: L'UID de l'user 'root' sera toujours égal à l'UID=0
if [[ $(id -u) == "0" ]]; then
	echo "Le script a été lancé en root !";
	echo -e "Et ça ... \nBah c'est interdit !\nAllez salut !";
	echo -e "J'dirais même...\nÀ plus dans l'bus !";
	stop_script;
fi;

#### DÉBUT: VERIFICATION DES PARAMÈTRES ####

# IF: Deux arguments obligatoire
if [ $# != 2 ]; then
	echo "ERROR: Deux arguments sont requis !";
	echo "Vous en avez fournis:${#}";
	stop_script;
fi;

# IF: Le chemin existe
if ! [[ -e ${PATH_TO_IMG} ]]; then 
	echo "Le chemin que vous avez fournis n'existe pas !";
	stop_script;
fi;

# IF: Le dossier de stockage des img existe bien
if ! [[ -d ${PATH_TO_IMG} ]]; then 
	echo "Le chemin que vous avez fournis n'est pas un dossier !";
	stop_script;
fi;

# IF: Le chemin est readable
if ! [[ -r ${PATH_TO_IMG} ]]; then 
	echo "Le chemin n'est pas lisible (chmod +r)";
	stop_script;
fi;

# IF: Le Chemin est executable
if ! [[ -x ${PATH_TO_IMG} ]]; then 
	echo "Le chemin n'est pas executable (chmod +x)";
	stop_script;
fi;

# IF: Le nom de l'album fait au moins 4 caractères
if [[ ${#ALBUM_NAME} -lt 4 ]]; then
	echo "Le nom de votre album photo doit faire au moins 4 caractères;";
	stop_script;
fi;

# IF: L'album n'existe pas déjà ?
if [[ -d "${PATH_TO_ALBUM}" ]]; then 
	echo "L'album '${ALBUM_NAME}' existe déjà ('${PATH_TO_ALBUM}...')";
	stop_script;
fi;

# IF: La commande convert existe
if ! [[ $(type convert) ]]; then
	echo "La commande 'convert' n'est pas présente !";
	echo "Veuillez installer ImageMagick avant de lancer le script";
	stop_script;
fi;

#### FIN: VERIFICATION DES PARAMÈTRES ####

echo "INFORMATION: l'album sera créé dans le chemin '${PATH_TO_ALBUM}...' ";
echo -e "Le répertoire '${HOME}/Albums' sera créé une seule fois \net sera utilisé comme base pour tous les albums générés";

# Si le dossier 'Albums' n'existe pas, on le créé
if ! [[ -d "${HOME}/Albums" ]]; then 
	mkdir "${HOME}/Albums";
fi;

# Création du dossier de l'album car, et pas de vérif car déjà vérifié qu'il n'existait pas
#mkdir "${PATH_TO_ALBUM}";

# Création des dossiers structures
#mkdir "${PATH_TO_ALBUM}/thumbnails";
#mkdir "${PATH_TO_ALBUM}/originaux";

mkdir -p "${PATH_TO_ALBUM}/{thumbnails,originaux}";

# Création du fichier .html de base
touch "${PATH_TO_ALBUM}/index.html";

# Construction de la balise "Title"
TITLE_TAG="<title>Album: ${ALBUM_NAME}</title>";

# Construction de la balise "H1" + "DATE"
H1_DATE="<h1>${ALBUM_NAME}<small>Créer le $(date +"%m-%d-%Y")</small></h1>";

echo "<html><head>${TITLE_TAG}<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><style>
.grid-wrap{padding:1%}.list-block{float:left;margin:1%;width:31.33333%;font-size:0;overflow:hidden}.list-block figure{position:relative;display:block;color:#000;text-align:center}.list-block figure:after{background:#fff;width:100%;height:100%;position:absolute;left:0;bottom:0;content:'';filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=70);opacity:.7;-webkit-transform:skew(-45deg) scaleX(0);-ms-transform:skew(-45deg) scaleX(0);transform:skew(-45deg) scaleX(0);-moz-transition:all .3s ease-in-out;-o-transition:all .3s ease-in-out;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.list-block figure:hover:after{-webkit-transform:skew(-45deg) scaleX(1);-ms-transform:skew(-45deg) scaleX(1);transform:skew(-45deg) scaleX(1);-moz-transition:all 400ms cubic-bezier(0.175,0.885,0.32,1.275);-o-transition:all 400ms cubic-bezier(0.175,0.885,0.32,1.275);-webkit-transition:all 400ms cubic-bezier(0.175,0.885,0.32,1.275);transition:all 400ms cubic-bezier(0.175,0.885,0.32,1.275)}.list-block figure:hover figcaption h2,.list-block figure:hover figcaption p{-moz-transform:translate3d(0%,0%,0);-webkit-transform:translate3d(0%,0%,0);transform:translate3d(0%,0%,0);-webkit-transition-delay:.2s;transition-delay:.2s}.list-block figure:hover figcaption h2{filter:progid:DXImageTransform.Microsoft.Alpha(enabled=false);opacity:1}.list-block figure:hover figcaption p{filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=70);opacity:.7}.list-block img{filter:progid:DXImageTransform.Microsoft.Alpha(enabled=false);opacity:1;max-width:100%;min-width:100%;-moz-transition:opacity .35s ease;-o-transition:opacity .35s ease;-webkit-transition:opacity .35s ease;transition:opacity .35s ease}.list-block figcaption{position:absolute;top:50%;left:0;width:100%;-moz-transform:translateY(-50%);-ms-transform:translateY(-50%);-webkit-transform:translateY(-50%);transform:translateY(-50%);z-index:1}.list-block h2,.list-block p{margin:0;width:100%;filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=0);opacity:0}.list-block h2{padding:0 30px 10px;display:inline-block;font-weight:400;text-transform:uppercase;font-size:24px}.list-block p{padding:0 50px;font-size:14px;text-transform:uppercase}*{box-sizing:border-box;-moz-transition:all .6s ease;-o-transition:all .6s ease;-webkit-transition:all .6s ease;transition:all .6s ease}body{background:#00d2ff;background:-webkit-linear-gradient(to left,#00d2ff,#3a7bd5);background:linear-gradient(to left,#00d2ff,#3a7bd5);font-family:'Roboto',sans-serif}h1{color:#fff;padding:4%;font-size:30px;text-transform:uppercase;font-weight:700;text-align:center}h1 small{font-size:18px;display:block;text-transform:none;font-weight:300;margin-top:5px}</style></head><body>
${H1_DATE}
<div class=\"grid-wrap\">" >> "${PATH_TO_ALBUM}index.html" 

# Pour prendre en compte les espaces dans les noms de fichiers 
# Je t'ai trouvé de la doc en fr sur IFS ici : https://michauko.org/blog/ifs-separateurs-scripts-bash-174/
IFS=$(echo -en "\n\b") 

for IMG in $(ls "${PATH_TO_IMG}"); do

	ERROR='';
	case $(file --mime-type -b "${PATH_TO_IMG}${IMG}") in
		image/jpeg)	ERROR=false;;
		image/png)	ERROR=false;;
		*) 			ERROR=true;;
	esac


	if [[ ${ERROR} == false ]]; then
		echo "Traitement de la photo '${IMG}'...";
		cp "${PATH_TO_IMG}${IMG}" "${PATH_TO_ALBUM}originaux/${IMG}"
		convert "${PATH_TO_IMG}${IMG}" -thumbnail 585x388 -background "black" -gravity center -extent 585x388 "${PATH_TO_ALBUM}thumbnails/${IMG}" > /dev/null 2>&1
		if [[ $? == 0 ]]; then
			#IMG_ARRAY=(${IMG//./ });
			#IMG_NAME=${IMG_ARRAY[0]};
			IMG_NAME=$(basename -- "$IMG") 
			IMG_NAME="${IMG_NAME%.*}"

			echo "<a class=\"list-block\" href=\"./originaux/${IMG}\">
				<figure>
					<img src=\"./thumbnails/${IMG}\" alt=\"\" />
					<figcaption>
						<h2>${IMG_NAME}</h2>
						<p>${PATH_TO_ALBUM}originaux/${IMG}</p>
					</figcaption>
				</figure>
			</a>" >> "${PATH_TO_ALBUM}/index.html"
		else
			echo "La photo: '${IMG}' est corrompue !";
			echo "Elle ne sera donc pas ajouté à l'album !";
		fi

	else
		echo "Le fichier '${IMG}' est de type: $(file --mime-type -b ${PATH_TO_IMG}${IMG})";
		echo "Il doit donc être supprimé";
		echo -e "INFO: Pour le développement du script\nIl ne sera pas supprimé pour pouvoir tester le script.sh\nSinon je dois le remettre dans le dossier à chaque fois\net c'est chiant"; 
	fi;

done

echo "</div></body><html>" >> "${PATH_TO_ALBUM}index.html" 

cd "${PATH_TO_ALBUM}";
echo "Lancement du serveur";
python -m SimpleHTTPServer
