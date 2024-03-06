set ANT_OPTS=-Xmx512m -Dinfo.aduna.platform.appdata.basedir=.\webapps\openrdf-sesame\app_dir\ -Dorg.eclipse.jetty.LEVEL=WARN

sw\ant\bin\ant.bat -S -f local.build.xml %1 %2 %3 %4 %5 %6 %7 %8 %9
