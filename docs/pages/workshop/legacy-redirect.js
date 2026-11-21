const movedSections = {
  "02_git_github.html": {
    "inspect-the-project-and-create-a-branch": "#git-practice",
    "create-a-provenance-note": "#git-practice",
    "stage-and-commit-one-change": "#git-practice",
    "share-and-request-review": "#git-practice",
    "git-checkpoint": "#open-science-checkpoint",
  },
  "03_environments.html": {
    "inspect-the-current-environment": "#inspect-the-r-environment",
    "inspect-and-restore-a-lockfile": "#after-the-workshop-record-your-own-environment",
    "try-it-yourself-restart-reload-record": "#record-the-session",
  },
  "04_data_documentation.html": {
    introduction: "#how-to-follow-this-segment",
    "data-dictionary": "#create-fair-metadata",
    "dataset-metadata": "#create-fair-metadata",
    "try-it-yourself": "#fair-follow-up",
  },
  "05_pins.html": {
    "create-a-versioned-board": "#store-dataset-versions-with-pins",
    "write-and-describe-two-versions": "#store-dataset-versions-with-pins",
    "try-it-yourself": "#store-dataset-versions-with-pins",
    "pins-checkpoint": "#versioning-checkpoint",
  },
  "06_targets.html": {
    "inspect-the-pipeline": "#the-pipeline-at-a-glance",
    "run-the-full-dataset": "#check-dependencies",
    "try-it-yourself": "07_modify_and_reproduce.html#change-input",
  },
  "07_quarto.html": {
    "inspect-the-report-source": "#step-2-read-the-report-source",
    "render-the-html-report": "#step-1-copy-and-render-the-template",
    "try-it-yourself": "#step-4-render-again-and-check-the-numbers",
    "publishing-demonstration": "#quarto-publishing",
    "quarto-extensions-for-journal-articles": "#quarto-publishing",
  },
  "08_zenodo.html": {
    "inspect-a-record": "#inspect-a-zenodo-record",
    "connect-the-website-repository-and-archive": "#inspect-a-zenodo-record",
    "try-it-yourself": "#zenodo-checkpoint",
  },
  "09_extras_and_discussion.html": {
    "model-versioning": "04_versioning.html#store-model-versions-with-vetiver",
    "prepare-the-study-summaries": "10_synthetic_data.html#prepare-the-study-summaries",
    "synthetic-study-summaries": "10_synthetic_data.html#generate-synthetic-study-summaries",
  },
};

const {pathname, hash, search} = window.location;
const legacyPage = pathname.split("/").pop();
const sections = movedSections[legacyPage] || {};
const sectionId = hash.slice(1);
const target = Object.prototype.hasOwnProperty.call(sections, sectionId)
  ? sections[sectionId]
  : hash;
const chapter = document.getElementById("current-chapter");
const destination = new URL(target, chapter.href);
destination.search = search;
window.location.replace(destination.href);
