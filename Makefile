PREFIX = /usr/local

install:
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f sgc sgd ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/share/sg
	@cp -r examples plotters ${DESTDIR}${PREFIX}/share/sg
	@mkdir -p ${DESTDIR}/usr/lib/systemd/system/
	@cp sgd@.service ${DESTDIR}/usr/lib/systemd/system/

.PHONY: install
