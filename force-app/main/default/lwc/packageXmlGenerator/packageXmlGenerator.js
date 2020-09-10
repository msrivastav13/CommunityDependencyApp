const VERSION = 49.0;

const createHeader = () => {
    let header = '<?xml version="1.0" encoding="UTF-8"?>\n';
    header =
        header + '<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n';
    return header;
};

const createFooter = (version) => {
    let footer = '  <version>' + version + '</version>\n';
    footer = footer + '</Package>\n';
    return footer;
};

const startType = () => {
    return '  <types>\n';
};

const endType = () => {
    return '  </types>\n';
};

const nameTag = (metadataType) => {
    return '    <name>' + metadataType + '</name>\n';
};

const createMember = (member) => {
    return '    <members>' + member + '</members>\n';
};

const groupBy = (list, keyGetter) => {
    const map = new Map();
    list.forEach((item) => {
        const key = keyGetter(item);
        const collection = map.get(key);
        if (!collection) {
            map.set(key, [item]);
        } else {
            collection.push(item);
        }
    });
    return map;
};

const createpackagexml = (results) => {
    let metadataxml = createHeader();
    const metadataResults = groupBy(
        results,
        (result) => result.RefMetadataComponentType
    );
    console.log(metadataResults);
    for (let [key, metadataitems] of metadataResults) {
        metadataxml += startType();
        for (let i = 0; i < metadataitems.length; i++) {
            const metadataitem = metadataitems[i];
            metadataxml += createMember(metadataitem.RefMetadataComponentName);
        }
        metadataxml += nameTag(key);
        metadataxml += endType();
    }
    metadataxml += createFooter(VERSION);
    return metadataxml;
};

export { createpackagexml };
