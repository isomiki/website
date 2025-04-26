import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time"]

  connect() {
    this.initialServerTime = new Date(this.timeTarget.dataset.time);
    this.initialClientTimestamp = Date.now();
    this.updateTime();
    this.interval = setInterval(() => this.updateTime(), 1000);
  }

  disconnect() {
    clearInterval(this.interval);
  }

  updateTime() {
    const elapsedMilliseconds = Date.now() - this.initialClientTimestamp;
    const currentTime = new Date(this.initialServerTime.getTime() + elapsedMilliseconds);

    const hours = currentTime.getHours().toString().padStart(2, '0');
    const minutes = currentTime.getMinutes().toString().padStart(2, '0');
    const formattedTime = `${currentTime.toLocaleString('default', { month: 'short' })} ${currentTime.getDate().toString().padStart(2, '0')} ${hours}:${minutes}`;

    if (this.timeTarget.textContent.trim() !== formattedTime) {
      this.timeTarget.textContent = formattedTime;
    }
  }
}
