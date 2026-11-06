'use strict';
'require ui';
'require view';

return view.extend({
	render() {
		const form = document.querySelector('form');
		const btn = document.querySelector('button');

		const dlg = ui.showModal(
			'OpenWrt',
			[
				E('div', { 'class': 'mmwx-login-intro' }, [
					E('span', { 'class': 'mmwx-login-mark', 'aria-hidden': 'true' }, '✦'),
					E('span', {}, _('Authorization Required'))
				]),
				...Array.from(document.querySelectorAll('section > *'))
			],
			'login'
		);

		let submitting = false;
		form.addEventListener('submit', (ev) => {
			if (submitting) {
				ev.preventDefault();
				return;
			}

			submitting = true;
			btn.disabled = true;
			btn.textContent = _('Logging in…');
		});

		const username = document.querySelector('input[name="luci_username"]');
		(username && !username.value ? username : document.querySelector('input[type="password"]')).focus();

		return '';
	},

	addFooter() {},

});
